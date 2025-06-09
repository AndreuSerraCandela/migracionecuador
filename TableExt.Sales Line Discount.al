/*tableextension 50139 tableextension50139 extends  //"Sales Line Discount"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        field(55000; "Cod. Oferta"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        cRep: Codeunit "Funciones Replicador DsPOS";
}*/

