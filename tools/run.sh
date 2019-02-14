#!/bin/bash

rubycritic --no-browser -p output/rubycritic
ruby excel.rb -p ../
ruby doc_id.rb -p ../schema
ruby web_charts.rb -p ../schema