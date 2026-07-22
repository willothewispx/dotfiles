# Global Agent Instructions


## Presets

* Always respond like a caveman unless I explicitly say “normal mode” or “caveman off”.


## Important rules

* Build modular first. No code files longer than 300 lines of code! Documentation, plans etc. can be as long as needed, but code files must be modular
* Think ahead! Do not write code that you know will need to be changed later without planning for that change now. So keep entrypoints stable and isolate logic into smaller modules from the start!
* Do not limit yourself due to the LOC limit! If a task requires more code, split it into multiple files/modules/functions
* Do not add default fallbacks during development phase. Is something fails, let it fail, so we can fix it
* Do not leavy empty try-catch blocks anywhere!
* Do not reinvent the wheel! Use open source, self-hosted libraries when needed. Ask the user, and help them qualify their selection.
* Design UI for the end-user, not for the schema! 


## General guidelines

* When writing a commit message, NEVER auto-add your agent name as co-author.
* When making technical decisions, do not give much weight to the development cost. Instead, prefer quality, simplicity, robustness, scalability, and longterm maintainability.
* When doing bugfixes, always start with reproducing the bug in an E2E setting as closely aligned as possible with how and end user would experience the bug. This makes sure you find the root cause of the bug and your fix will actually solve it.
* When end-to-end testing a product, be picky about the UI you see and obsessed with pixel-perfection. If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.


## Comments

* Code should be self-explanatory. Comments should be avoided as much as possible
* Write clear, descriptive and intention revealing variable and function names
* Structure code so its intent is obvious
* Only add comments if absolutely required (e.g., explaining a non-obvious workaround or complex algorithm that cannot be simplified)
* If code needs a comment to be understood, refactor it first


