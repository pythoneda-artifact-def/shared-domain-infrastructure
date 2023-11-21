# Domain Infrastructure artifact

# Definition for pythoneda-shared-pythoneda-artifact/domain-infrastructure

Definition of [pythoneda-shared-pythoneda-artifact](https://github.com/pythoneda-shared-pythoneda-artifact "pythoneda-shared-pythoneda-artifact")/[domain](https://github.com/pythoneda-shared-pythoneda-artifact/domain-infrastructure "domain-infrastructure").

## How to declare it in your flake

Annotate the latest version of this repository and use it instead of the `[version]` placeholder below:

```nix
{
  description = "[..]";
  inputs = rec {
    [..]
    pythoneda-shared-pythoneda-artifact-domain-infrastructure = {
      [optional follows]
      url =
        "github:pythoneda-shared-pythoneda-artifact-def/domain-infrastructure/[version]";
    };
  };
  outputs = [..]
};
```

Should you use another PythonEDA modules, you might want to pin those also used by this project. The same applies to [nixpkgs](https://github.com/nixos/nixpkgs "nixpkgs") and [flake-utils](https://github.com/numtide/flake-utils "flake-utils").

Use the specific package depending on your system (one of `flake-utils.lib.defaultSystems`) and Python version:

- `#packages.[system].pythoneda-shared-pythoneda-artifact-domain-infrastructure-python38` 
- `#packages.[system].pythoneda-shared-pythoneda-artifact-domain-infrastructure-python39` 
- `#packages.[system].pythoneda-shared-pythoneda-artifact-domain-infrastructure-python310` 
- `#packages.[system].pythoneda-shared-pythoneda-artifact-domain-infrastructure-python311` 
