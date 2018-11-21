#!/usr/bin/env bash

file=$1

sed -i 's/RECURSIVE              = NO/RECURSIVE              = YES/g' $file
sed -i 's/EXTRACT_ALL            = NO/EXTRACT_ALL            = YES/g' $file
sed -i 's/CLASS_GRAPH            = NO/CLASS_GRAPH            = YES/g' $file
sed -i 's/HIDE_UNDOC_RELATIONS   = YES/HIDE_UNDOC_RELATIONS   = NO/g' $file
sed -i 's/HAVE_DOT               = NO/HAVE_DOT               = YES/g' $file
sed -i 's/CLASS_GRAPH            = NO/CLASS_GRAPH            = YES/g' $file
sed -i 's/COLLABORATION_GRAPH    = NO/COLLABORATION_GRAPH    = YES/g' $file
sed -i 's/UML_LOOK               = NO/UML_LOOK               = YES/g' $file
sed -i 's/TEMPLATE_RELATIONS     = NO/TEMPLATE_RELATIONS     = YES/g' $file
sed -i 's/DOT_TRANSPARENT        = NO/DOT_TRANSPARENT        = YES/g' $file

sed -i 's/UML_LIMIT_NUM_FIELDS   = 10/UML_LIMIT_NUM_FIELDS   = 50/g' $file
sed -i 's/DOT_GRAPH_MAX_NODES    = 50/DOT_GRAPH_MAX_NODES    = 100/g' $file
sed -i 's/MAX_DOT_GRAPH_DEPTH    = 0/MAX_DOT_GRAPH_DEPTH    = 0/g' $file

