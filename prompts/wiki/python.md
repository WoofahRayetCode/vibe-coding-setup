# ⚡ Bleeding-Edge Python Master-Branch Reference Wiki

This document serves as an authoritative, high-density reference library strictly aligned with the **latest bleeding-edge Python (CPython) Master specifications (v3.12 / v3.13+)**. It covers advanced static typing, modern syntax features, and low-level performance considerations for writing highly optimized, future-proof Python code.

---

## 1. Type Parameter Syntax & Generics (PEP 695 / 696)
Python 3.12+ introduces a cleaner, native syntax for defining generic classes, functions, and type aliases, removing the need for verbose `TypeVar` declarations.

### 📋 Modern Type Aliases and Generic Functions:
```python
# Modern type alias syntax (PEP 695)
type Point = tuple[float, float]
type Vector[T: (int, float)] = list[T]  # Constrained to int or float

# Generic function with dynamic type parameter (no TypeVar required)
def get_first[T](items: list[T]) -> T:
    return items[0]

# Generic class with modern syntax
class Box[T]:
    def __init__(self, content: T) -> None:
        self.content = content

# Default Type Parameters (PEP 696 - Python 3.13+)
type Callback[T = str] = Callable[[T], None]
```

---

## 2. Advanced Static Typing & Type Narrowing
Leverage modern static typing features to catch bugs early and speed up Editor auto-completions.

### 📋 Modern Overrides, TypedDicts, and Type Narrowing:
```python
from typing import override, TypedDict, TypeIs, ReadOnly

class Base:
    def execute(self) -> str:
        return "Base"

class Child(Base):
    @override  # Static verification of method overriding (PEP 698)
    def execute(self) -> str:
        return "Child"

# ReadOnly TypedDict parameters (PEP 705 - Python 3.13+)
class UserConfig(TypedDict):
    username: str
    admin: ReadOnly[bool]

# Advanced Type Narrowing using TypeIs (Python 3.13+)
def is_str_list(val: list[object]) -> TypeIs[list[str]]:
    return all(isinstance(x, str) for x in val)
```

---

## 3. Ergonomic f-Strings (PEP 701)
Python 3.12+ removes previous parser restrictions on f-strings, allowing nested quotes, backslashes, and comments inside expressions.

### 📋 Nested and Multi-line f-Strings:
```python
# Reuse of quotes and backslashes inside f-string expressions
result = f"User list: {', '.join([ 'user_1', 'user_2' ])}"

# Multi-line expressions with inline comments inside f-strings
details = f"User state: {
    # Check authorization flag
    'Authorized' if user.is_authenticated 
    else 'Guest'
}"
```

---

## 4. Performance & Memory Best Practices
* **Comprehension Inlining (PEP 709)**: List, dict, and set comprehensions are now automatically inlined by the compiler (faster runtime execution, zero temporary frame creation overhead).
* **Experimental Free-Threaded Mode (PEP 703 - Python 3.13+)**: Be aware of builds running with `--disable-gil`. Multi-threaded code can run with true multi-core parallel execution. Use thread-safe data structures where concurrency is high.
* **Experimental JIT Compiler (PEP 744 - Python 3.13+)**: Optimizes hot code paths dynamically. Prefer writing local, focused loops to allow the JIT optimizer to compile them cleanly.
