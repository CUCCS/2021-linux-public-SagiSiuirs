#!/usr/bin/env bash

function Help {
    echo "-as                统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比"
    echo "-ls                统计不同场上位置的球员数量、百分比"
    echo "-n                 名字最长的球员是谁？名字最短的球员是谁？"
    echo "-a                 年龄最大的球员是谁？年龄最小的球员是谁？"
    echo "-h                 帮助文档"
}

# 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
function AgeStatistics {
    awk -F "\t" '
        BEGIN {a=0; b=0; c=0;}
        $6!="Age" {
            if($6>=0&&$6<20) {a++;}
            else if($6<=30) {b++;}
            else {c++;}
        }
        END {
            sum=a+b+c;
            printf("年龄\t数量\t百分比\n");
            printf("<20\t%d\t%f%%\n",a,a*100.0/sum);
            printf("[20,30]\t%d\t%f%%\n",b,b*100.0/sum);
            printf(">30\t%d\t%f%%\n",c,c*100.0/sum);
        }' worldcupplayerinfo.tsv
}

# 统计不同场上位置的球员数量、百分比
function LocationStatistics {
    awk -F "\t" '
        BEGIN {sum=0}
        $5!="Position" {
            pos[$5]++;
            sum++;
        }
        END {
            printf("    位置\t数量\t百分比\n");
            for(i in pos) {
                printf("%13s\t%d\t%f%%\n",i,pos[i],pos[i]*100.0/sum);
            }
        }' worldcupplayerinfo.tsv
}

# 名字最长的球员是谁？名字最短的球员是谁？
function  NameLength {
    awk -F "\t" '
        BEGIN {max=-1; min=9999;}
        $9!="Player" {
            len=length($9);
            names[$9]=len;
            max=len>max?len:max;
            min=len<min?len:min;
        }
        END {
            for(i in names) {
                if(names[i]==max) {
                    printf("名字最长的球员是%s.\n", i);
                } else  if(names[i]==min) {
                    printf("名字最短的球员是%s.\n", i);
                }
            }
        }' worldcupplayerinfo.tsv
}

# 年龄最大的球员是谁？年龄最小的球员是谁？
function Age {
    awk -F "\t" '
        BEGIN {max=-1; min=999;}
        $6!="Age"  {
            age=$6;
            names[$9]=age;
            max=age>max?age:max;
            min=age<min?age:min;
        }
        END {
            printf("年龄最大的球员是%d岁的\t", max);
            for(i in names) {
                if(names[i]==max) { printf("%s\n", i); }
            }
            printf("年龄最小的球员是%d岁的\t", min);
            for(i in names) {
                if(names[i]==min) { printf("%s\n", i); }
            }
        }' worldcupplayerinfo.tsv
}

# 主程序
while [ "$1" != "" ];do
    case "$1" in
        "-as")
            AgeStatistics
            exit 0
            ;;
        "-ls")
            LocationStatistics
            exit 0
            ;;
        "-n")
            NameLength
            exit 0
            ;;
        "-a")
            Age
            exit 0
            ;;
        "-h")
            Help
            exit 0
            ;;
    esac
done