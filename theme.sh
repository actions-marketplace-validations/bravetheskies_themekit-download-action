git checkout ${{ env.branch }}

echo "Installing Theme Kit"
curl -s https://shopify.github.io/themekit/scripts/install.py | sudo python

echo "Configuring Theme Kit"
theme configure --password=${{ secrets.SHOPIFY_APP_API_PASSWORD }} --store=${{ secrets.SHOPIFY_STORE_URL }} --themeid=${{ secrets.SHOPIFY_THEME_ID }} --dir=${{ secrets.THEME_PATH }} --ignored-file=config/settings_data.json --ignored-file=locales/*

echo "Downloading theme files"
theme download

git add .

if ! git diff-index --quiet HEAD --; then
  echo "Changes found, commiting and pushing"
  git commit -m "Changes from live on CI run $GITHUB_RUN_NUMBER"
  git push
  hub pull-request --no-edit
else
  echo "No changes found"
fi