#!/bin/bash

for object in $(aws s3api list-objects --bucket test-ardika-4 --query 'Contents[].{Key: Key, Size: Size}' --output text | grep -E '\]|\%|\}|\$|\&|\@|\=|\;|\:|\+|\,|\?|\\|\{|\^|\[|\~|\#|\U+003E|\U+003C' | awk '{print $1}');

    do
    
    echo "Renaming $object"
    aws s3 mv s3://test-ardika-4/$object s3://test-ardika-4/$(echo $object | sed 's|[<>!@#$%^%&*()-+]||g');
    echo ""

done;
