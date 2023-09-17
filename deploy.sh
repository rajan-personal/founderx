rm -rf docs
mkdir docs
cd founderx
flutter build web --release
cp -r build/web/* ../docs
cd ..
cd docs
sed -i '' 's|<base href="/">|<base href="https://founderx.mysave.app/">|g' index.html
echo "founderx.mysave.app" >> CNAME