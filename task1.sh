#! /usr/bin/env bash


function Help() {
    echo "-q Q               对JPEG格式图片进行质量压缩 质量因子为Q"
    echo "-r R               对JPEG/PNG/SVG格式图片在保持原始宽高比的前提下压缩分辨率 R"
    echo "-w font_size text  对图片批量添加自定义文本水印"
    echo "-p text            批量重命名 统一添加文件名前缀 不影响原始文件扩展名"
    echo "-s text            批量重命名 统一添加文件名后缀 不影响原始文件扩展名"
    echo "-t                 将PNG/SVG图片统一转换为JPG格式"
    echo "-h                 帮助文档"
}

#对JPEG格式图片进行质量压缩
function QualityCompression {
    Q=$1
    for i in *;do
        type=${i##*.}
        if [[ ${type} == "jpg" || ${type} == "jpeg" || ${type} == "JPEG" ]];then
            convert "${i}" -quality "${Q}" "${i}"
            echo "${i} 质量压缩完成"
        fi
    done
}

#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function CompressionResolution {
    R=$1
    for i in *;do
        type=${i##*.}
        if [[ ${type} == "jpg" || ${type} == "png" || ${type} != "svg" || ${type} == "jpeg" || ${type} == "JPEG" ]];then
            convert "${i}" -resize "${R}" "${i}"
            echo "${i} 分辨率压缩完成"
        fi
    done
}

#对图片批量添加自定义文本水印
function AddCustomWatermark {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "png" && ${type} != "svg" && ${type} != "jpeg" && ${type} != "JPEG" ]];then continue;fi;
        convert "${i}" -pointsize "$1" -fill blue -gravity center -draw "text 10,15 '$2'" "${i}"
        echo "${i} 自定义文本水印 $2 已添加完成"
    done
}

#批量重命名，统一添加文件名前缀，不影响原始文件扩展名
function AddPrefix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "png" && ${type} != "svg" && ${type} != "jpeg" && ${type} != "JPEG" ]]; then continue; fi;
        mv "${i}" "$1""${i}"
        echo " ${i} 已添加前缀 $1${i} "
    done
}

#批量重命名：统一添加文件名后缀，不影响原始文件扩展名
function AddSuffix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "png" && ${type} != "svg" && ${type} != "jpeg" && ${type} != "JPEG" ]]; then continue; fi;
        newname=${i%.*}$1"."${type}
        mv "${i}" "${newname}"
        echo " ${i} 已添加后缀 ${newname} "
    done
}

#将png/svg图片统一转换为jpg格式图片
function ImageTransition_jpg {
    for i in *;do
        type=${i##*.}
        if [[ ${type} == "png" || ${type} == "svg" ]]; then
            newname=${i%.*}".jpg"
            convert "${i}" "${newname}"
   	        echo " ${i} 已转换为 ${newname} "
        fi
    done
}

#main
while [ "$1" != "" ];do
    case "$1" in
        "-q")
            QualityCompression "$2"
            exit 0
            ;;
        "-r")
            CompressionResolution "$2"
            exit 0
            ;;
        "-w")
            AddCustomWatermark "$2" "$3"
            exit 0
            ;;
        "-p")
            AddPrefix "$2"
            exit 0
            ;;
        "-s")
            AddSuffix "$2"
            exit 0
            ;;
        "-t")
            ImageTransition_jpg
            exit 0
            ;;
        "-h")
            Help
            exit 0
            ;;
    esac
done