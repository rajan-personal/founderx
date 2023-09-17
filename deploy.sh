rm -rf docs
mkdir docs
cd founderx
flutter build web --release
cp -r build/web/* ../docs
cd ..
cd docs
echo "founderx.mysave.app" >> CNAME