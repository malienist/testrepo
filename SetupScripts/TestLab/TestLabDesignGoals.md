# Design Goals
## Uses
1. To start lab easily from Powershell 5.1 or Powershell 6 commandline
2. To enable new machines to be added / created rapidly
3. To use declarative programming principles to ensure baseline configuration is consistent

## Thoughts / Planning / Execution
### Thoughts
1. Need to ensure multiple types of virtualization - especially cloud.

## Purpose
1. This cannot be a full blown dynamic lab solution. It is for testing discrete effects before deployment onto a network
2. This changes the scope to being fairly simple

## Assumptions
1. Home lab has 32 Gb ram OR it's in the cloud in which case it's arbitary
2. The user will want to create custom effects on the fly, so simplicity of use is key
3. To effectively risk mitigate, the configuration of the test lab should be constant