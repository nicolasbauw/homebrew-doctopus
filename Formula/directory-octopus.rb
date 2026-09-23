class DirectoryOctopus < Formula
  desc "Retro-inspired dual-pane file manager"
  # directory-octopus (github.com/nicolasbauw/directory-octopus) est un
  # dépôt privé : un lien vers lui ne mènerait nulle part pour qui installe
  # via ce tap. Page officielle pas encore publiée à ce jour.
  homepage "https://theorangenerd.ovh/#do"
  # Binaire déjà compilé par la GitHub Action du dépôt (job "macos"),
  # hébergé sur le site de l'auteur — pas construit ici. Ce n'est pas non
  # plus construit "from source" en CI depuis ce tarball : plus personne
  # d'autre que l'auteur ne peut télécharger le tarball source d'un dépôt
  # privé.
  url "https://theorangenerd.ovh/doctopus/directory-octopus-1.0.0-macos-arm64.tar.gz"
  version "1.0.0"
  sha256 "c9e4c2bea3e9b9dea82929d1a2b803777b7ae406babc199c0495c15359a51fce"
  license "MIT OR Apache-2.0"

  def install
    bin.install "directory-octopus"
    prefix.install "DirectoryOctopus.app" if OS.mac?
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      Directory Octopus also installs as a macOS bundle
      (#{prefix}/DirectoryOctopus.app), for normal launching/pinning from
      the Dock or Launchpad — instead of the bare binary in #{bin}. To add
      it to Applications:

        ln -s "#{prefix}/DirectoryOctopus.app" /Applications/DirectoryOctopus.app

      This binary is downloaded pre-built (from theorangenerd.ovh) rather
      than compiled here, and is unsigned. `brew` fetches it with curl, not
      Safari, so it is normally never quarantined — but if macOS still
      refuses to launch it ("cannot be opened because the developer cannot
      be verified", or on newer macOS "is damaged and can't be opened" for
      the very same reason), clear the flag by hand:

        xattr -d com.apple.quarantine "#{prefix}/DirectoryOctopus.app"
    EOS
  end

  test do
    # Pas de sous-commande "--version"/"--help" (voir src/main.rs) : lancer
    # le binaire sans argument ouvrirait une vraie fenêtre GUI, ce qu'un
    # `brew test` headless en CI ne peut pas faire. Seule vérification
    # possible ici : le binaire a bien été installé et est exécutable.
    assert_predicate bin/"directory-octopus", :exist?
    assert_predicate bin/"directory-octopus", :executable?
  end
end
