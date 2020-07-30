#!/bin/sh
sh load.sh serving/serving.image.list 0.15.0
sh load.sh istio/istio.image.list 1.6.1
sh load.sh sample/sample.image.list
