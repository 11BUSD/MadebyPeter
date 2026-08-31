# Application note

I built this because the interesting part of agent infrastructure is not a model generating text; it is safely moving work across boundaries and proving what happened.

Evidence Factory uses all three Solari surfaces in a single workflow:

1. browser for acquisition,
2. sandbox for isolated transformation and serving,
3. desktop for human-visible verification.

The output is intentionally boring in the best way: JSON, HTML, hashes, screenshots. A reviewer can inspect it without trusting the agent that created it.

If I joined Pine Tree Research, this is the direction I would keep pushing: primitives that make autonomous software workers observable, reproducible, and cheap enough to run continuously.
