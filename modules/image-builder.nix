{ self, inputs, ... }:

{
  perSystem =
    {
      pkgs,
      system,
      lib,
      ...
    }:
    {
      packages = {
        # Minimal qcow2 image - configured for Kyun.host (/dev/sda)
        default = inputs.nixos-generators.nixosGenerate {
          inherit system;
          format = "qcow";
          modules = [
            ../modules/kyun-base.nix
            {
              # 10GB virtual disk (compresses to ~600MB-1GB actual file size)
              virtualisation.diskSize = 10 * 1024;
            }
          ];
        };
      };

      # Add convenience app for building
      apps = {
        default = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "build-kyun-image" ''
              set -e
              echo "Building kyun.host cloud-init qcow2 image..."
              ${pkgs.nix}/bin/nix build .#default
              echo ""
              echo "✓ Image built successfully!"
              echo "  Output: result/nixos.qcow2"
              echo ""
              echo "Upload this image to kyun.host dashboard."
              echo "Cloud-init configuration will be provided by kyun.host at /dev/sr1"
            ''
          );
          meta = {
            description = "Build kyun.host cloud-init compatible qcow2 image";
          };
        };
      };
    };
}
