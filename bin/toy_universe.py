"""
Toy universe: sprout + inner-horn-fill dynamics on a directed graph.
Events form a causal poset (dependency = uses cells created by earlier events).
Entropy S(t) = log(# linear extensions of the event poset after t events).

Moves:
  sprout(v): new vertex w, new edge v->w.       parents = {creator_event(v)}
  fill(e1: u->v, e2: v->w): new edge u->w (composite) + 2-cell.
                                                 parents = {creator(e1), creator(e2)}
Non-deleting; inner horns only (composable pairs), each horn filled at most once.
"""

import random
import math
from itertools import combinations


class Universe:
    def __init__(self, seed):
        self.rng = random.Random(seed)
        # event 0 = big bang, creates vertex 0
        self.event_parents = [frozenset()]          # parents per event
        self.vertex_creator = {0: 0}                # vertex -> creating event
        self.edges = {}                             # edge id -> (u, v, creating event)
        self.out_edges = {0: []}                    # vertex -> list of edge ids
        self.in_edges = {0: []}
        self.filled = set()                         # set of (e1, e2) horn pairs filled
        self.next_vertex = 1
        self.next_edge = 0

    def _add_edge(self, u, v, ev):
        eid = self.next_edge
        self.next_edge += 1
        self.edges[eid] = (u, v, ev)
        self.out_edges.setdefault(u, []).append(eid)
        self.in_edges.setdefault(v, []).append(eid)
        self.out_edges.setdefault(v, [])
        self.in_edges.setdefault(u, [])
        return eid

    def unfilled_horns(self):
        horns = []
        for v in list(self.out_edges):
            for e1 in self.in_edges.get(v, []):
                for e2 in self.out_edges.get(v, []):
                    if (e1, e2) not in self.filled:
                        horns.append((e1, e2))
        return horns

    def sprout(self):
        v = self.rng.randrange(self.next_vertex)
        ev = len(self.event_parents)
        self.event_parents.append(frozenset({self.vertex_creator[v]}))
        w = self.next_vertex
        self.next_vertex += 1
        self.vertex_creator[w] = ev
        self._add_edge(v, w, ev)

    def fill(self, horn):
        e1, e2 = horn
        u = self.edges[e1][0]
        w = self.edges[e2][1]
        ev = len(self.event_parents)
        self.event_parents.append(frozenset({self.edges[e1][2], self.edges[e2][2]}))
        self._add_edge(u, w, ev)
        self.filled.add(horn)

    def tick(self, p_sprout):
        horns = self.unfilled_horns()
        if not horns or self.rng.random() < p_sprout:
            self.sprout()
            return "sprout"
        self.fill(self.rng.choice(horns))
        return "fill"


def count_linear_extensions(parents):
    """Exact count via DP over downsets (bitmask). parents: list of frozensets."""
    n = len(parents)
    parent_masks = [0] * n
    for i, ps in enumerate(parents):
        m = 0
        for p in ps:
            m |= 1 << p
        parent_masks[i] = m
    full = (1 << n) - 1
    counts = {0: 1}
    # process masks in order of popcount
    frontier = {0: 1}
    for _ in range(n):
        nxt = {}
        for mask, c in frontier.items():
            for i in range(n):
                bit = 1 << i
                if not (mask & bit) and (mask & parent_masks[i]) == parent_masks[i]:
                    nm = mask | bit
                    nxt[nm] = nxt.get(nm, 0) + c
        frontier = nxt
    return frontier.get(full, 0)


def run(p_sprout, n_events, seed):
    u = Universe(seed)
    S = [0.0]  # after just the big-bang event
    for _ in range(n_events - 1):
        u.tick(p_sprout)
        S.append(math.log(count_linear_extensions(u.event_parents)))
    return S


if __name__ == "__main__":
    N_EVENTS = 18
    SEEDS = range(6)
    ratios = [0.2, 0.5, 0.8]
    results = {}
    for p in ratios:
        runs = [run(p, N_EVENTS, s) for s in SEEDS]
        avg = [sum(r[t] for r in runs) / len(runs) for t in range(N_EVENTS)]
        results[p] = avg
        print(f"p_sprout={p}: final S = {avg[-1]:.3f}")

    import json
    with open("/home/claude/entropy_results.json", "w") as f:
        json.dump({str(k): v for k, v in results.items()}, f)
