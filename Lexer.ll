%{
#include <algorithm>
#include <vector>
#include <functional>
#include <string>
#include <map>
#include <iostream>
#include <sstream>
    using namespace std;
    string result = "";
%}
%s COMMENT
commenttag            "//!"
whitespace            [ \t\n\r]

%%
<INITIAL>^{whitespace}*{commenttag}         { result += "/**\n *"; BEGIN COMMENT; }
<COMMENT>^{whitespace}*{commenttag}         { result += " *"; BEGIN COMMENT; }
<COMMENT>^{whitespace}+                     { result += "*/\n"; result +=yytext; BEGIN INITIAL; }
<COMMENT>\\param                            { result += "@param"; BEGIN COMMENT; }
<COMMENT>\\sa                               { result += "@see"; BEGIN COMMENT; }
<COMMENT>\\retval                           { result += "@return"; BEGIN COMMENT; }
<COMMENT>\\return                           { result += "@return"; BEGIN COMMENT; }
<COMMENT>\\typedef                          { result += "@typedef"; BEGIN COMMENT; }
<COMMENT>\\class                            { result += "@class"; BEGIN COMMENT; }
<COMMENT>\\brief                            { result += "@brief"; BEGIN COMMENT; }
<COMMENT>\\TODO                             { result += "@TODO"; BEGIN COMMENT; }
<COMMENT>{whitespace}                       { result +=yytext; }
<COMMENT>.                                  { result += yytext; BEGIN COMMENT; }
<INITIAL>{whitespace}                       { result += yytext; BEGIN INITIAL; }
<INITIAL>.                                  { result += yytext; BEGIN INITIAL; }
%%

int main(int argc, char** argv)
{
    string filename = "";
    if(argc > 1)
    {
        filename = argv[1];
        yyin = fopen(filename.c_str(),"r");
    }
    yylex();
    if(!filename.empty())
    {
        fclose(yyin);
        yyout = fopen(filename.c_str(),"w");
        fprintf(yyout,result.c_str());
        fclose(yyout);
    }
    else
        cout << result << endl;

    return 0;
}
