#!/usr/bin/env bash

AUTHOR="Kirill Pshenichnyi <pshcyrill@mail.ru>"
CMAKE_MIN_VERSION=3.16
CXX_STANDARD=23
C_STANDARD=23

SRC_SUFFIX="cpp"
HDR_SUFFIX="h"

ARG_LICENSE_PRIVATE="n"
ARG_LICENSE_GPL="y"
ARG_WITH_QT="n"
ARG_WITH_GTEST="n"

workdir=`pwd`/$1
project_name=$1

lsrc_dir=src
source_dir=${workdir}/${lsrc_dir}
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

    echo "cmake_minimum_required(VERSION ${CMAKE_MIN_VERSION})"
    echo ""
    echo "set(PROGRAM_NAME ${project_name})"
    echo "project(\${PROGRAM_NAME})"
    echo "set(SOURCES_SUBDIR ${lsrc_dir})"
    echo ""
    echo "# Output directories: "
    echo "# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/lib)"
    echo "# set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)"
    echo "set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)"
    echo ""
    echo "set(INCLUDES \${PROJECT_SOURCE_DIR}/\${SOURCES_SUBDIR})"
    echo ""
    echo "set(CMAKE_C_STANDARD ${C_STANDARD})"
    echo "set(CMAKE_C_STANDARD_REQUIRED ON)"
    echo "set(CMAKE_CXX_STANDARD ${CXX_STANDARD})"
    echo "set(CMAKE_CXX_STANDARD_REQUIRED ON)"
    echo ""

    if [[ ${ARG_WITH_QT} == "y" ]]; then
	echo "set(CMAKE_AUTOMOC ON)"
	echo "set(CMAKE_AUTORCC ON)"
	echo "set(CMAKE_AUTOUIC ON)"
	echo ""
	echo "find_package(Qt6 COMPONENTS Core REQUIRED)"
	echo "find_package(Qt6 COMPONENTS Gui REQUIRED)"
	echo "find_package(Qt6 COMPONENTS Widgets REQUIRED)"
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

function CLANG_FORMAT() {
    echo "---
Language:        Cpp
AccessModifierOffset: -8
AlignAfterOpenBracket: Align
AlignArrayOfStructures: None
AlignConsecutiveAssignments:
  Enabled:         false
  AcrossEmptyLines: false
  AcrossComments:  false
  AlignCompound:   false
  AlignFunctionPointers: false
  PadOperators:    true
AlignConsecutiveBitFields:
  Enabled:         false
  AcrossEmptyLines: false
  AcrossComments:  false
  AlignCompound:   false
  AlignFunctionPointers: false
  PadOperators:    false
AlignConsecutiveDeclarations:
  Enabled:         false
  AcrossEmptyLines: false
  AcrossComments:  false
  AlignCompound:   false
  AlignFunctionPointers: false
  PadOperators:    false
AlignConsecutiveMacros:
  Enabled:         false
  AcrossEmptyLines: false
  AcrossComments:  false
  AlignCompound:   false
  AlignFunctionPointers: false
  PadOperators:    false
AlignConsecutiveShortCaseStatements:
  Enabled:         false
  AcrossEmptyLines: false
  AcrossComments:  false
  AlignCaseArrows: false
  AlignCaseColons: false
AlignConsecutiveTableGenBreakingDAGArgColons:
  Enabled:         false
  AcrossEmptyLines: false
  AcrossComments:  false
  AlignCompound:   false
  AlignFunctionPointers: false
  PadOperators:    false
AlignConsecutiveTableGenCondOperatorColons:
  Enabled:         false
  AcrossEmptyLines: false
  AcrossComments:  false
  AlignCompound:   false
  AlignFunctionPointers: false
  PadOperators:    false
AlignConsecutiveTableGenDefinitionColons:
  Enabled:         false
  AcrossEmptyLines: false
  AcrossComments:  false
  AlignCompound:   false
  AlignFunctionPointers: false
  PadOperators:    false
AlignEscapedNewlines: Left
AlignOperands:   Align
AlignTrailingComments:
  Kind:            Always
  OverEmptyLines:  0
AllowAllArgumentsOnNextLine: true
AllowAllParametersOfDeclarationOnNextLine: true
AllowBreakBeforeNoexceptSpecifier: Never
AllowShortBlocksOnASingleLine: Never
AllowShortCaseExpressionOnASingleLine: true
AllowShortCaseLabelsOnASingleLine: false
AllowShortCompoundRequirementOnASingleLine: true
AllowShortEnumsOnASingleLine: false
AllowShortFunctionsOnASingleLine: All
AllowShortIfStatementsOnASingleLine: WithoutElse
AllowShortLambdasOnASingleLine: All
AllowShortLoopsOnASingleLine: true
AlwaysBreakAfterDefinitionReturnType: None
AlwaysBreakBeforeMultilineStrings: true
AttributeMacros:
  - __capability
BinPackArguments: true
BinPackParameters: false
BitFieldColonSpacing: Both
BraceWrapping:
  AfterCaseLabel:  false
  AfterClass:      false
  AfterControlStatement: Never
  AfterEnum:       false
  AfterExternBlock: false
  AfterFunction:   false
  AfterNamespace:  false
  AfterObjCDeclaration: false
  AfterStruct:     false
  AfterUnion:      false
  BeforeCatch:     false
  BeforeElse:      false
  BeforeLambdaBody: false
  BeforeWhile:     false
  IndentBraces:    false
  SplitEmptyFunction: true
  SplitEmptyRecord: true
  SplitEmptyNamespace: true
BreakAdjacentStringLiterals: true
BreakAfterAttributes: Leave
BreakAfterJavaFieldAnnotations: false
BreakAfterReturnType: None
BreakArrays:     true
BreakBeforeBinaryOperators: None
BreakBeforeConceptDeclarations: Always
BreakBeforeBraces: Attach
BreakBeforeInlineASMColon: OnlyMultiline
BreakBeforeTernaryOperators: true
BreakConstructorInitializers: BeforeColon
BreakFunctionDefinitionParameters: false
BreakInheritanceList: BeforeColon
BreakStringLiterals: true
BreakTemplateDeclarations: Yes
ColumnLimit:     80
CommentPragmas:  '^ IWYU pragma:'
CompactNamespaces: false
ConstructorInitializerIndentWidth: 4
ContinuationIndentWidth: 4
Cpp11BracedListStyle: true
DerivePointerAlignment: true
DisableFormat:   false
EmptyLineAfterAccessModifier: Never
EmptyLineBeforeAccessModifier: LogicalBlock
ExperimentalAutoDetectBinPacking: false
FixNamespaceComments: true
ForEachMacros:
  - foreach
  - Q_FOREACH
  - BOOST_FOREACH
IfMacros:
  - KJ_IF_MAYBE
IncludeBlocks:   Regroup
IncludeCategories:
  - Regex:           '^<ext/.*\.h>'
    Priority:        2
    SortPriority:    0
    CaseSensitive:   false
  - Regex:           '^<.*\.h>'
    Priority:        1
    SortPriority:    0
    CaseSensitive:   false
  - Regex:           '^<.*'
    Priority:        2
    SortPriority:    0
    CaseSensitive:   false
  - Regex:           '.*'
    Priority:        3
    SortPriority:    0
    CaseSensitive:   false
IncludeIsMainRegex: '([-_](test|unittest))?$'
IncludeIsMainSourceRegex: ''
IndentAccessModifiers: false
IndentCaseBlocks: false
IndentCaseLabels: true
IndentExternBlock: AfterExternBlock
IndentGotoLabels: true
IndentPPDirectives: None
IndentRequiresClause: true
IndentWidth:     8
IndentWrappedFunctionNames: false
InsertBraces:    false
InsertNewlineAtEOF: false
InsertTrailingCommas: None
IntegerLiteralSeparator:
  Binary:          0
  BinaryMinDigits: 0
  Decimal:         0
  DecimalMinDigits: 0
  Hex:             0
  HexMinDigits:    0
JavaScriptQuotes: Leave
JavaScriptWrapImports: true
KeepEmptyLines:
  AtEndOfFile:     false
  AtStartOfBlock:  false
  AtStartOfFile:   true
LambdaBodyIndentation: Signature
LineEnding:      DeriveLF
MacroBlockBegin: ''
MacroBlockEnd:   ''
MainIncludeChar: Quote
MaxEmptyLinesToKeep: 1
NamespaceIndentation: None
ObjCBinPackProtocolList: Never
ObjCBlockIndentWidth: 2
ObjCBreakBeforeNestedBlockParam: true
ObjCSpaceAfterProperty: false
ObjCSpaceBeforeProtocolList: true
PackConstructorInitializers: NextLine
PenaltyBreakAssignment: 2
PenaltyBreakBeforeFirstCallParameter: 1
PenaltyBreakComment: 300
PenaltyBreakFirstLessLess: 120
PenaltyBreakOpenParenthesis: 0
PenaltyBreakScopeResolution: 500
PenaltyBreakString: 1000
PenaltyBreakTemplateDeclaration: 10
PenaltyExcessCharacter: 1000000
PenaltyIndentedWhitespace: 0
PenaltyReturnTypeOnItsOwnLine: 200
PointerAlignment: Left
PPIndentWidth:   -1
QualifierAlignment: Leave
RawStringFormats:
  - Language:        Cpp
    Delimiters:
      - cc
      - CC
      - cpp
      - Cpp
      - CPP
      - 'c++'
      - 'C++'
    CanonicalDelimiter: ''
    BasedOnStyle:    google
  - Language:        TextProto
    Delimiters:
      - pb
      - PB
      - proto
      - PROTO
    EnclosingFunctions:
      - EqualsProto
      - EquivToProto
      - PARSE_PARTIAL_TEXT_PROTO
      - PARSE_TEST_PROTO
      - PARSE_TEXT_PROTO
      - ParseTextOrDie
      - ParseTextProtoOrDie
      - ParseTestProto
      - ParsePartialTestProto
    CanonicalDelimiter: pb
    BasedOnStyle:    google
ReferenceAlignment: Pointer
ReflowComments:  true
RemoveBracesLLVM: false
RemoveParentheses: Leave
RemoveSemicolon: false
RequiresClausePosition: OwnLine
RequiresExpressionIndentation: OuterScope
SeparateDefinitionBlocks: Leave
ShortNamespaceLines: 1
SkipMacroDefinitionBody: false
SortIncludes:    CaseSensitive
SortJavaStaticImport: Before
SortUsingDeclarations: LexicographicNumeric
SpaceAfterCStyleCast: false
SpaceAfterLogicalNot: false
SpaceAfterTemplateKeyword: true
SpaceAroundPointerQualifiers: Default
SpaceBeforeAssignmentOperators: true
SpaceBeforeCaseColon: false
SpaceBeforeCpp11BracedList: true
SpaceBeforeCtorInitializerColon: true
SpaceBeforeInheritanceColon: true
SpaceBeforeJsonColon: false
SpaceBeforeParens: ControlStatements
SpaceBeforeParensOptions:
  AfterControlStatements: true
  AfterForeachMacros: true
  AfterFunctionDefinitionName: false
  AfterFunctionDeclarationName: false
  AfterIfMacros:   true
  AfterOverloadedOperator: false
  AfterPlacementOperator: true
  AfterRequiresInClause: false
  AfterRequiresInExpression: false
  BeforeNonEmptyParentheses: false
SpaceBeforeRangeBasedForLoopColon: true
SpaceBeforeSquareBrackets: false
SpaceInEmptyBlock: false
SpacesBeforeTrailingComments: 2
SpacesInAngles:  Never
SpacesInContainerLiterals: true
SpacesInLineCommentPrefix:
  Minimum:         1
  Maximum:         -1
SpacesInParens:  Never
SpacesInParensOptions:
  ExceptDoubleParentheses: false
  InCStyleCasts:   false
  InConditionalStatements: false
  InEmptyParentheses: false
  Other:           false
SpacesInSquareBrackets: false
Standard:        Auto
StatementAttributeLikeMacros:
  - Q_EMIT
StatementMacros:
  - Q_UNUSED
  - QT_REQUIRE_VERSION
TableGenBreakInsideDAGArg: DontBreak
TabWidth:        8
UseTab:          Never
VerilogBreakBetweenInstancePorts: true
WhitespaceSensitiveMacros:
  - BOOST_PP_STRINGIZE
  - CF_SWIFT_NAME
  - NS_SWIFT_NAME
  - PP_STRINGIZE
  - STRINGIZE
...
"
}

function GITINGORE() {
    echo "/build/"
    echo "/bin/"
    echo "/.cache/"

    echo ${source_dir}/config.h
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

cd ${workdir}
git init
# if [[ "${ARG_LICENSE_GPL}" == "y" ]]; then
# 	curl 'https://www.gnu.org/licenses/gpl-3.0.txt' > LICENSE
#       git add LICENSE
# fi

CMAKE_MAIN_FILE > CMakeLists.txt
CLANG_FORMAT > .clang-format
GITINGORE > .gitignore
git add CMakeLists.txt  .clang-format .gitignore

cd ${source_dir}
MAIN_SRC_CONTENT | clang-format > main.${SRC_SUFFIX}
git add main.${SRC_SUFFIX}
