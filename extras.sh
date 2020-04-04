#!/bin/bash
python -c "import nltk;nltk.download('wordnet')"
wget https://dl.bintray.com/boostorg/release/1.63.0/source/boost_1_63_0.zip
unzip boost_1_63_0.zip
sudo mv boost_1_63_0 /usr/local/bin
