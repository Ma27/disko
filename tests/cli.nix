{ pkgs ? (import <nixpkgs> { })
, makeDiskoTest ? (pkgs.callPackage ./lib.nix { }).makeDiskoTest
}:
makeDiskoTest {
  name = "cli";
  disko-config = ../example/complex.nix;
  extraConfig = {
    fileSystems."/zfs_legacy_fs".options = [ "nofail" ]; # TODO find out why we need this!
  };
  testMode = "cli";
  extraTestScript = ''
    machine.succeed("test -b /dev/zroot/zfs_testvolume");
    machine.succeed("test -b /dev/md/raid1p1");


    machine.succeed("mountpoint /zfs_fs");
    machine.succeed("mountpoint /zfs_legacy_fs");
    machine.succeed("mountpoint /ext4onzfs");
    machine.succeed("mountpoint /ext4_on_lvm");
  '';
  extraConfig = {
    boot.kernelModules = [ "dm-raid" "dm-mirror" ];
  };
}
