{
	description = "Joshua's NixOS System";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

		nixgl.url = "github:nix-community/nixGL";
		
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		zen-browser = {
			url = "github:youwen5/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		vicinae = {
			url = "github:vicinaehq/vicinae";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{
		self,
		nixpkgs,
		nixgl,
		home-manager,
		zen-browser,
		vicinae,
		...
	}:
	{
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";

			specialArgs = {
				inherit inputs;
			};

			modules = [
				./configuration.nix

				home-manager.nixosModules.home-manager

				vicinae.nixosModules.default

				{
					nixpkgs.overlays = [ nixgl.overlay ];
					
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;

					home-manager.extraSpecialArgs = {
						inherit inputs;
					};
					
					home-manager.users.joshua = import ./home.nix;
				}
			];
		};
	};
}
