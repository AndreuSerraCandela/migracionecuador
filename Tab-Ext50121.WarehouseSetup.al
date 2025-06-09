tableextension 50121 "Warehouse Setup" extends "Warehouse Setup"
{
    fields
    {
        field(50000; "Metodo clasificacion defecto"; Option)
        {
            Caption = 'Metodo clasificacion defecto';
            DataClassification = ToBeClassified;
            OptionMembers = ,Item,Document,"Shelf or Bin","Due Date",Destination,"Bin Ranking","Action Type";
            OptionCaptionML = ESM = ' ,Prod.,Doc.,Estantería o ubic.,Fecha vto.,Destino,Ranking ubic.,Tipo acción';
        }
    }
}