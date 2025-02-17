#!/bin/sh
set -e

homepage="https://github.com/pact-foundation/pact-plugins"
version=$1
DESCRIPTION="Standalone Pact Plugin CLI executable"
TOOL_NAME=pact-plugin-cli
TOOL_NAME_PASCAL=PactPluginCli
MAJOR_TAG=$(echo $version | cut -d '.' -f 1)
MINOR_TAG=$(echo $version | cut -d '.' -f 2)
PATCH_TAG=$(echo $version | cut -d '.' -f 3)
FORMULA_DIR=Formula
if [[ $LATEST == "true" ]]; then
    FORMULAE_FILE="$FORMULA_DIR/$TOOL_NAME.rb"
    FORMULA_NAME="$TOOL_NAME_PASCAL"
elif [[ $LATEST_VERSION ]]; then
    FORMULAE_FILE="$FORMULA_DIR/${TOOL_NAME}@$MAJOR_TAG.rb"
    FORMULA_NAME="${TOOL_NAME_PASCAL}AT${MAJOR_TAG}"
else
    FORMULAE_FILE="$FORMULA_DIR/$TOOL_NAME-$version.rb"
    FORMULA_NAME="$TOOL_NAME_PASCAL$MAJOR_TAG$MINOR_TAG$PATCH_TAG"
fi

write_homebrew_formulae() {
    if [ ! -f "$FORMULAE_FILE" ] ; then
        touch "$FORMULAE_FILE"
    else
        : > "$FORMULAE_FILE"
    fi


    filename_macos_arm=$TOOL_NAME-v$version/$TOOL_NAME-osx-aarch64.gz
    filename_macos_x64=$TOOL_NAME-v$version/$TOOL_NAME-osx-x86_64.gz
    filename_linux_arm=$TOOL_NAME-v$version/$TOOL_NAME-linux-aarch64.gz
    filename_linux_x64=$TOOL_NAME-v$version/$TOOL_NAME-linux-x86_64.gz


     exec 3<> $FORMULAE_FILE
        echo "class $FORMULA_NAME < Formula" >&3
        echo "  desc \"$DESCRIPTION\"" >&3
        echo "  homepage \"$homepage\"" >&3
        echo "  version \"$version\"" >&3
        echo "" >&3
        if [[ $sha_osx_x86_64 ]]; then
        echo "  on_macos do" >&3
            if [[ $sha_osx_arm64 ]]; then
            echo "    on_arm do" >&3
            echo "      url \"$homepage/releases/download/$filename_macos_arm\"" >&3
            echo "      sha256 \"${sha_osx_arm64}\"" >&3
            echo "    end" >&3
            else
            echo "    on_arm do" >&3
            echo "      url \"$homepage/releases/download/$filename_macos_x64\"" >&3
            echo "      sha256 \"${sha_osx_x86_64}\"" >&3
            echo "    end" >&3
            fi
        echo "    on_intel do" >&3
        echo "      url \"$homepage/releases/download/$filename_macos_x64\"" >&3
        echo "      sha256 \"${sha_osx_x86_64}\"" >&3
        echo "    end" >&3
        echo "  end" >&3
        echo "" >&3
        fi
        if [[ $filename_linux_x64 ]]; then
        echo "  on_linux do" >&3
        if [[ $sha_linux_arm64 ]]; then
        echo "    on_arm do" >&3
        echo "      url \"$homepage/releases/download/$filename_linux_arm\"" >&3
        echo "      sha256 \"${sha_linux_arm64}\"" >&3
        echo "    end" >&3
        fi
        echo "    on_intel do" >&3
        echo "      url \"$homepage/releases/download/$filename_linux_x64\"" >&3
        echo "      sha256 \"${sha_linux_x86_64}\"" >&3
        echo "    end" >&3
        echo "  end" >&3
        fi
        echo "" >&3
        echo "  def install" >&3
        echo "    # pact-reference" >&3
        echo "    bin.install Dir[\"*\"]; puts \"# Run '$TOOL_NAME --help'\"" >&3
        if [[ -z $sha_osx_arm64 ]]; then
            echo "    on_macos do" >&3
            echo "      on_arm do" >&3
            echo "        puts \"# Rosetta is required to run $TOOL_NAME commands\"" >&3
            echo "        puts \"# sudo softwareupdate --install-rosetta --agree-to-license\"" >&3
            echo "      end" >&3
            echo "    end" >&3      
        fi
        echo "  end" >&3
        echo "" >&3
        echo "  test do" >&3
        echo "    system \"#{bin}/$TOOL_NAME\", \"--help\"" >&3
        echo "  end" >&3
        echo "end" >&3
    exec 3>&-
}

display_help() {
    echo "This script must be run from the root folder."
}

display_usage() {
    echo "\nCreate a versionsed formula of $TOOL_NAME\"\n"
    echo "\nUsage:\n\"./scripts/update_tap_version_plugin_cli.sh 1.64.1\"\n"
    echo "\nCreate a pull request at end on run\"\n"
    echo "\nUsage:\n\"CREATE_PR=true ./scripts/update_tap_version_plugin_cli.sh 1.64.1\"\n"
    echo "\nCreate as latest version\"\n"
    echo "\nUsage:\n\"LATEST=true ./scripts/update_tap_version_plugin_cli.sh 1.64.1\"\n"
}

if [[ $# -eq 0 ]] ; then
    echo "🚨 Please supply the $TOOL_NAME version to upgrade to"
    display_usage
    exit 1
elif [[ $1 == "--help" ||  $1 == "-h" ]] ; then
    display_help
    display_usage
    exit 1
else




archs=(x86_64 aarch64)
platforms=(linux osx)
shas=()
for platform in ${platforms[@]}; do 
    for arch in ${archs[@]}; do 

        filename=$TOOL_NAME-${platform}-${arch}

        echo "⬇️  Downloading $version $filename.gz from $homepage"
        curl -LO $homepage/releases/download/$TOOL_NAME-v$version/$filename.gz

        brewshasignature=( $(eval "openssl dgst -sha256 $filename.gz") )
        echo "🔏 Checksum SHA256:\t ${brewshasignature[1]} for ${arch}"




            echo "⬇️  Downloading $version $filename.gz.sha256 for ${platform}-${arch}"
            echo "curl -LO $homepage/releases/download/$TOOL_NAME-v$version/$filename.gz.sha256"
            curl -LO $homepage/releases/download/$TOOL_NAME-v$version/$filename.gz.sha256

            expectedsha=( $(eval "cat $filename.gz.sha256") )
            echo "🔏 Expected SHA1:\t ${expectedsha[0]} for ${platform}-${arch}"

            if [ "${brewshasignature[1]}" == "${expectedsha[0]}" ]; then
                echo "👮‍♀️ SHA Check: 👍 for ${arch}"
            else
                echo "👮‍♀️ SHA Check: 🚨 - checksums do not match! for ${arch}"
                exit 1
            fi
            echo "🧹 Cleaning up..."
            rm $filename.gz
            rm $filename.gz.sha256
            echo "🔏 Checksum SHA256:\t ${brewshasignature[1]} for ${platform}-${arch}"
            echo "🧪 Writing formulae..."
            shas+=(${brewshasignature[1]})

    done 
done 


    sha_linux_x86_64=${shas[0]}
    sha_linux_arm64=${shas[1]}
    sha_osx_x86_64=${shas[2]}
    sha_osx_arm64=${shas[3]}

    echo "sha_osx_arm64:" $sha_osx_arm64
    echo "sha_osx_x86_64:" $sha_osx_x86_64
    echo "sha_linux_arm64:" $sha_linux_arm64
    echo "sha_linux_x86_64:" $sha_linux_x86_64

    write_homebrew_formulae

    if [[ ! -n "${CREATE_PR}" ]] 
    then
        echo "🎉 Done!"
    else
        git checkout -b version/v$version
        git add $FORMULAE_FILE
        git commit -m "chore(release): Update version to v$version"
        git push --set-upstream origin version/v$version

        echo "👏  Go and open that PR now:"
        echo "🔗  $homepage/compare/master...version/v$version"

        hub pull-request --message "chore(release): Update version to v${version}"
        echo "🎉 Done!"
    fi


    exit 0
fi
