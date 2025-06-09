tableextension 50025 tableextension50025 extends "G/L Account Where-Used"
{

    //Unsupported feature: Code Modification on "Caption(PROCEDURE 1)".
    //Actualmente el codigo ya es como el que se modifico 

    //procedure Caption();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    exit(
      CopyStr(StrSubstNo('%1 %2',"G/L Account No.","G/L Account Name"),1,100));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    exit(StrSubstNo('%1 %2',"G/L Account No.","G/L Account Name"));
    */
    //end;
}

