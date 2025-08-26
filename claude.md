# Claude rules

## Code structure
* There are 3 spearate projects under backend, frontend and landing_page. They each have their own stack and can be modified, tested and deployed separately. If you are asked to make changes, determine which project needs changing and avoid unnecessary changes in other projects. 

## General
* Do not automatically read the contents under .ai_coding/ direcotry. I will explicitly direct you to do so when needed.

## When modifying or adding code

### KISS (Keep It Simple, Stupid)
* Write straightforward, uncomplicated solutions
* Avoids over-engineering and unnecessary complexity
* The produced code must be readable and maintainable by humans

### YAGNI (You Aren't Gonna Need It)
* Do not add speculative features
* Focuses on implementing only what's currently needed
* Reduce code bloat and maintenance overhead

### SOLID Principles
* Single Responsibility Principle: Each component handles only one concern
* Open-Closed Principle: open to extensions, closed to modifications
* Liskov Substitution Principle: Subtypes must be able to replace parent types
* Interface Segregation Principle: Use specific interfaces rather than generic interfaces
* Dependency Inversion Principle: rely on abstraction rather than concrete implementation