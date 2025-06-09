tableextension 50104 tableextension50104 extends "Item Unit of Measure"
{

    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TestItemUOM;
    CheckNoEntriesWithUoM;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TestItemUOM;
    CheckNoEntriesWithUoM;

    // MdM 18/09/17
    if not wModificadoMdM then
      cGestMdm.GestNotityUnid(xRec, Rec, true);
    */
    //end;


    //Unsupported feature: Code Insertion on "OnInsert".

    //trigger OnInsert()
    //begin
    /*
    cRep.Item("Item No.");
    // MdM 18/09/17
    if not wModificadoMdM then
      cGestMdm.GestNotityUnid(xRec, Rec, false);
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
    /*
    cRep.Item("Item No.");
    // MdM 18/09/17
    if not wModificadoMdM then
       cGestMdm.GestNotityUnid(xRec, Rec, false);
    */
    //end;

    procedure SetModificadoMdM(prMod: Boolean)
    begin
        // SetModificadoMdM
        //  MdM Indicamos que ha sido modificado por MdM

        wModificadoMdM := prMod;
    end;

    var
        "***Santillana***": Integer;
        cRep: Codeunit "Funciones Replicador DsPOS";
        cGestMdm: Codeunit "Gest. Maestros MdM";
        wModificadoMdM: Boolean;
}

