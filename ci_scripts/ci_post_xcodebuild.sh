#! /bin/bash
# requires curl and jq on PATH: https://stedolan.github.io/jq/

# create a new release 
# user: user's name 
# repo: the repo's name
# token: github api user token
# tag: name of the tag pushed 
create_release() {
    user=$1
    repo=$2
    token=$3
    tag=$4

    command="curl -s -o release.json -w '%{http_code}' \
         --request POST \
         --header 'authorization: Bearer ${token}' \
         --header 'content-type: application/json' \
         --data '{\"tag_name\": \"${tag}\"}' \
         https://api.github.com/repos/$user/$repo/releases"
    http_code=`eval $command`
    if [ $http_code == "201" ]; then
        echo "created release:"
        cat release.json
    else
        echo "create release failed with code '$http_code':"
        cat release.json
        echo "command:"
        echo $command
        return 1
    fi
}

# upload a release file. 
# this must be called only after a successful create_release, as create_release saves 
# the json response in release.json. 
# token: github api user token
# file: path to the asset file to upload 
# name: name to use for the uploaded asset
upload_release_file() {
    token=$1
    file=$2
    name=$3

    url=`jq -r .upload_url release.json | cut -d{ -f'1'`
    command="\
      curl -s -o upload.json -w '%{http_code}' \
           --request POST \
           --header 'authorization: Bearer ${token}' \
           --header 'Content-Type: application/octet-stream' \
           --data-binary @\"${file}\"
           ${url}?name=${name}"
    http_code=`eval $command`
    if [ $http_code == "201" ]; then
        echo "asset $name uploaded:"
        jq -r .browser_download_url upload.json
    else
        echo "upload failed with code '$http_code':"
        cat upload.json
        echo "command:"
        echo $command
        return 1
    fi
}

brew install jq

if [[ -n $CI_DEVELOPER_ID_SIGNED_APP_PATH ]];
then
    echo "Archive path is available"
    # Move up to parent directory
    cd ..
    echo "$CI_DEVELOPER_ID_SIGNED_APP_PATH"
    CURRENT_PROJECT_VERSION=$(xcodebuild -project TuistBarTool.xcodeproj -showBuildSettings | grep "MARKETING_VERSION" | sed 's/[ ]*MARKETING_VERSION = //')
    echo "Version $CURRENT_PROJECT_VERSION"

    zip -qr ./release.zip $CI_DEVELOPER_ID_SIGNED_APP_PATH

    create_release $USER TuistBarTool $TOKEN $CURRENT_PROJECT_VERSION
    upload_release_file $TOKEN ./release.zip $CURRENT_PROJECT_VERSION

else
    echo "Archive path isn't available"
fi
