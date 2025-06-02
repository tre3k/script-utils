#!/usr/bin/env bash

AUTHOR="Kirill Pshenichnyi <pshcyrill@mail.ru>"

SRC_SUFFIX="cpp"
HDR_SUFFIX="h"

ARG_LICENSE_PRIVATE="n"
ARG_LICENSE_GPL="y"
ARG_WITH_QT="n"
ARG_WITH_GTEST="n"

workdir=`pwd`/$1
project_name=$1

source_dir=${workdir}/src
test_dir=${source_dir}/test


function LICENSE_CPP_HEADER() {
    if [[ ${ARG_LICENSE_GPL} == "y" ]]; then
	echo -e \
	     "/*                                                                         \n" \
	     "*  Copyright © `date +%Y` ${AUTHOR}                                       \n" \
	     "*										\n" \
	     "*  This file is part of $project_name.					\n" \
	     "*										\n" \
	     "*  $project_name is free software: you can redistribute it and/or modify	\n" \
	     "*  it under the terms of the GNU General Public License as published by	\n" \
	     "*  the Free Software Foundation, either version 3 of the License, or	\n" \
	     "*  (at your option) any later version.					\n" \
	     "*										\n" \
	     "*  $project_name is distributed in the hope that it will be useful,	\n" \
	     "*  but WITHOUT ANY WARRANTY; without even the implied warranty of		\n" \
	     "*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the		\n" \
	     "*  GNU General Public License for more details.				\n" \
	     "*										\n" \
	     "*  You should have received a copy of the GNU General Public License	\n" \
	     "*  along with $project_name. If not, see <https://www.gnu.org/licenses/>. \n" \
	     "*										\n" \
	     "*     Author: ${AUTHOR}			                                \n" \
	     "*/                                                                        \n"
    fi
    if [[ ${ARG_LICENSE_PRIVATE} == "y" ]]; then
	echo -e \
	     "/*\n"\
	     "*  Copyright © `date +%Y` ${AUTHOR}  \n" \
	     "*    All rights reserved \n" \
    	     "*/\n"
    fi

}

function CMAKE_MAIN_FILE() {
    if [[ "${ARG_LICENSE_GPL}" == "y" ]]; then
	echo -e \
	     " #                                                                        \n" \
	     "#  Copyright © `date +%Y` ${AUTHOR}                                       \n" \
	     "#										\n" \
	     "#  This file is part of $project_name.					\n" \
	     "#										\n" \
	     "#  $project_name is free software: you can redistribute it and/or modify	\n" \
	     "#  it under the terms of the GNU General Public License as published by	\n" \
	     "#  the Free Software Foundation, either version 3 of the License, or	\n" \
	     "#  (at your option) any later version.					\n" \
	     "#										\n" \
	     "#  $project_name is distributed in the hope that it will be useful,	\n" \
	     "#  but WITHOUT ANY WARRANTY; without even the implied warranty of		\n" \
	     "#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the		\n" \
	     "#  GNU General Public License for more details.				\n" \
	     "#										\n" \
	     "#  You should have received a copy of the GNU General Public License	\n" \
	     "#  along with $project_name. If not, see <https://www.gnu.org/licenses/>. \n" \
	     "#										\n" \
	     "#     Author: ${AUTHOR}			                                \n" \
	     "#                                                                         \n"
    fi
    if [[ ${ARG_LICENSE_PRIVATE} == "y" ]]; then
	echo -e \
	     "#\n"\
	     "#  Copyright © `date +%Y` ${AUTHOR}  \n" \
	     "#    All rights reserved \n" \
    	     "#/\n"
    fi

}

function MAIN_SRC_CONTENT() {
    LICENSE_CPP_HEADER
    if [[ ${ARG_WITH_QT} == "y" ]]; then
	echo "#include <QApplication>"
    fi

    echo  ""
    echo "int main(int argc, char **argv) {"

    if [[ ${ARG_WITH_QT} == "y" ]]; then
	echo -e \
	     "        auto app = new QApplication(argc, argv);\n" \
	     "        return app.exec();"

    else
	echo "        return 0;"
    fi
    echo "}"
}

function help() {
    echo $0
    echo -e "\t--license-gpl -gpl\tAdd GPL License file and header (default)"
    echo -e "\t--license-private\tPrivate Licnese"

}

shift
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --license-private)
	    ARG_LICENSE_PRIVATE="y"
	    ARG_LICENSE_GPL="n"
	    ;;
	-gpl|--license-gpl)
	    ARG_LICENSE_GPL="y"
	    ;;
	-qt|--with-qt)
	    ARG_WITH_QT="y"
	    ;;
	-gtest|--with-gtest)
	    ARG_WITH_GTEST="y"
	    ;;
        *)
	    help
	    exit 1
	    ;;
    esac
    shift
done

mkdir -p ${workdir}
cd ${workdir}
mkdir -p ${source_dir}

if [[ ${ARG_WITH_GTEST} == "y" ]]; then
    mkdir -p ${test_dir}
fi

# if [[ "${ARG_LICENSE_GPL}" == "y" ]]; then
# 	curl 'https://www.gnu.org/licenses/gpl-3.0.txt' > LICENSE
# fi

cd ${workdir}
CMAKE_MAIN_FILE #> CMakeLists.txt
cd ${source_dir}
MAIN_SRC_CONTENT #> main.${SRC_SUFFIX}
