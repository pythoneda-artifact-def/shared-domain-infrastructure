# flake.nix
#
# This file packages pythoneda-shared-pythonlang-artf/infrastructure as a Nix flake.
#
# Copyright (C) 2023-today rydnr's pythoneda-shared-pythonlang-artf-def/infrastructure
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description = "Nix flake for pythoneda-shared-pythonlang-artf/infrastructure";
  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    pythoneda-shared-pythonlang-artf-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-pythonlang-artf-def/domain/0.0.73";
    };
    pythoneda-shared-artifact-artifact-events-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      inputs.pythoneda-shared-pythonlang-infrastructure.follows =
        "pythoneda-shared-pythonlang-infrastructure";
      url =
        "github:pythoneda-shared-artifact-def/artifact-events-infrastructure/0.0.61";
    };
    pythoneda-shared-artifact-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      inputs.pythoneda-shared-pythonlang-infrastructure.follows =
        "pythoneda-shared-pythonlang-infrastructure";
      url = "github:pythoneda-shared-artifact-def/infrastructure/0.0.74";
    };
    pythoneda-shared-pythonlang-banner = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:pythoneda-shared-pythonlang-def/banner/0.0.72";
    };
    pythoneda-shared-pythonlang-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      url = "github:pythoneda-shared-pythonlang-def/domain/0.0.96";
    };
    pythoneda-shared-pythonlang-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-pythonlang-def/infrastructure/0.0.72";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "pythoneda-shared-pythonlang-artf";
        repo = "infrastructure";
        version = "0.0.19";
        sha256 = "184f5br6zg64a3vg48pd2jgi5cqb3z5y1v4x1skm9i8j3p8h4gsg";
        pname = "${org}-${repo}";
        pythonpackage = "pythoneda.artifact.shared.infrastructure";
        pkgs = import nixpkgs { inherit system; };
        description =
          "Infrastructure layer for pythoneda-shared-pythonlang-artf/domain";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = with pkgs.lib.maintainers;
          [ "rydnr <github@acm-sl.org>" ];
        archRole = "B";
        space = "A";
        layer = "I";
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import "${pythoneda-shared-pythonlang-banner}/nix/shared.nix";
        pythoneda-shared-pythonlang-artf-infrastructure-for = { python
          , pythoneda-shared-artifact-artifact-events-infrastructure
          , pythoneda-shared-artifact-infrastructure
          , pythoneda-shared-pythonlang-domain, pythoneda-shared-pythonlang-artf-domain
          , pythoneda-shared-pythonlang-infrastructure }:
          let
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTomlTemplate = ./templates/pyproject.toml.template;
            pyprojectToml = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              inherit homepage pname pythonMajorMinorVersion package
                version;
              package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
              pythonedaSharedArtifactArtifactEventsInfrastructure =
                pythoneda-shared-artifact-artifact-events-infrastructure.version;
              pythonedaSharedArtifactInfrastructure =
                pythoneda-shared-artifact-infrastructure.version;
              pythonedaSharedPythonlangArtfDomain =
                pythoneda-shared-pythonlang-artf-domain.version;
              pythonedaSharedPythonlangDomain =
                pythoneda-shared-pythonlang-domain.version;
              pythonedaSharedPythonlangInfrastructure =
                pythoneda-shared-pythonlang-infrastructure.version;
              src = pyprojectTomlTemplate;
            };
            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              pythoneda-shared-artifact-artifact-events-infrastructure
              pythoneda-shared-artifact-infrastructure
              pythoneda-shared-pythonlang-domain
              pythoneda-shared-pythonlang-artf-domain
              pythoneda-shared-pythonlang-infrastructure
            ];

            # pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              chmod +w $sourceRoot
              cp ${pyprojectToml} $sourceRoot/pyproject.toml
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              popd
              mkdir $out/dist
              cp dist/${wheelName} $out/dist
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = pythoneda-shared-pythonlang-artf-infrastructure-python312;
          pythoneda-shared-pythonlang-artf-infrastructure-python39 =
            shared.devShell-for {
              banner = "${
                  pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39
                }/bin/banner.sh";
              extra-namespaces = "";
              nixpkgs-release = nixpkgsRelease;
              package =
                packages.pythoneda-shared-pythonlang-artf-infrastructure-python39;
              python = pkgs.python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              inherit archRole layer org pkgs repo space;
            };
          pythoneda-shared-pythonlang-artf-infrastructure-python310 =
            shared.devShell-for {
              banner = "${
                  pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310
                }/bin/banner.sh";
              extra-namespaces = "";
              nixpkgs-release = nixpkgsRelease;
              package =
                packages.pythoneda-shared-pythonlang-artf-infrastructure-python310;
              python = pkgs.python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              inherit archRole layer org pkgs repo space;
            };
          pythoneda-shared-pythonlang-artf-infrastructure-python311 =
            shared.devShell-for {
              banner = "${
                  pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311
                }/bin/banner.sh";
              extra-namespaces = "";
              nixpkgs-release = nixpkgsRelease;
              package =
                packages.pythoneda-shared-pythonlang-artf-infrastructure-python311;
              python = pkgs.python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              inherit archRole layer org pkgs repo space;
            };
          pythoneda-shared-pythonlang-artf-infrastructure-python312 =
            shared.devShell-for {
              banner = "${
                  pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312
                }/bin/banner.sh";
              extra-namespaces = "";
              nixpkgs-release = nixpkgsRelease;
              package =
                packages.pythoneda-shared-pythonlang-artf-infrastructure-python312;
              python = pkgs.python312;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              inherit archRole layer org pkgs repo space;
            };
          pythoneda-shared-pythonlang-artf-infrastructure-python313 =
            shared.devShell-for {
              banner = "${
                  pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313
                }/bin/banner.sh";
              extra-namespaces = "";
              nixpkgs-release = nixpkgsRelease;
              package =
                packages.pythoneda-shared-pythonlang-artf-infrastructure-python313;
              python = pkgs.python313;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python313;
              inherit archRole layer org pkgs repo space;
            };
        };
        packages = rec {
          default = pythoneda-shared-pythonlang-artf-infrastructure-python312;
          pythoneda-shared-pythonlang-artf-infrastructure-python39 =
            pythoneda-shared-pythonlang-artf-infrastructure-for {
              python = pkgs.python39;
              pythoneda-shared-artifact-artifact-events-infrastructure =
                pythoneda-shared-artifact-artifact-events-infrastructure.packages.${system}.pythoneda-shared-artifact-artifact-events-infrastructure-python39;
              pythoneda-shared-artifact-infrastructure =
                pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              pythoneda-shared-pythonlang-artf-domain =
                pythoneda-shared-pythonlang-artf-domain.packages.${system}.pythoneda-shared-pythonlang-artf-domain-python39;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python39;
            };
          pythoneda-shared-pythonlang-artf-infrastructure-python310 =
            pythoneda-shared-pythonlang-artf-infrastructure-for {
              python = pkgs.python310;
              pythoneda-shared-artifact-artifact-events-infrastructure =
                pythoneda-shared-artifact-artifact-events-infrastructure.packages.${system}.pythoneda-shared-artifact-artifact-events-infrastructure-python310;
              pythoneda-shared-artifact-infrastructure =
                pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              pythoneda-shared-pythonlang-artf-domain =
                pythoneda-shared-pythonlang-artf-domain.packages.${system}.pythoneda-shared-pythonlang-artf-domain-python310;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python310;
            };
          pythoneda-shared-pythonlang-artf-infrastructure-python311 =
            pythoneda-shared-pythonlang-artf-infrastructure-for {
              python = pkgs.python311;
              pythoneda-shared-artifact-artifact-events-infrastructure =
                pythoneda-shared-artifact-artifact-events-infrastructure.packages.${system}.pythoneda-shared-artifact-artifact-events-infrastructure-python311;
              pythoneda-shared-artifact-infrastructure =
                pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              pythoneda-shared-pythonlang-artf-domain =
                pythoneda-shared-pythonlang-artf-domain.packages.${system}.pythoneda-shared-pythonlang-artf-domain-python311;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python311;
            };
          pythoneda-shared-pythonlang-artf-infrastructure-python312 =
            pythoneda-shared-pythonlang-artf-infrastructure-for {
              python = pkgs.python312;
              pythoneda-shared-artifact-artifact-events-infrastructure =
                pythoneda-shared-artifact-artifact-events-infrastructure.packages.${system}.pythoneda-shared-artifact-artifact-events-infrastructure-python312;
              pythoneda-shared-artifact-infrastructure =
                pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              pythoneda-shared-pythonlang-artf-domain =
                pythoneda-shared-pythonlang-artf-domain.packages.${system}.pythoneda-shared-pythonlang-artf-domain-python312;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python312;
            };
          pythoneda-shared-pythonlang-artf-infrastructure-python313 =
            pythoneda-shared-pythonlang-artf-infrastructure-for {
              python = pkgs.python313;
              pythoneda-shared-artifact-artifact-events-infrastructure =
                pythoneda-shared-artifact-artifact-events-infrastructure.packages.${system}.pythoneda-shared-artifact-artifact-events-infrastructure-python313;
              pythoneda-shared-artifact-infrastructure =
                pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python313;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python313;
              pythoneda-shared-pythonlang-artf-domain =
                pythoneda-shared-pythonlang-artf-domain.packages.${system}.pythoneda-shared-pythonlang-artf-domain-python313;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python313;
            };
        };
      });
}
