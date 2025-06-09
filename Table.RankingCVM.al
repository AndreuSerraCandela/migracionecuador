table 76178 "Ranking CVM"
{
    DrillDownPageID = "Promotores - Ppto Vtas";
    LookupPageID = "Promotores - Ppto Vtas";

    fields
    {
        field(1; "Cod. Docente"; Code[20])
        {
            NotBlank = true;
            TableRelation = Docentes;
        }
        field(2; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
            TableRelation = Contact WHERE (Type = CONST (Company));
        }
        field(3; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE ("Contact No." = FIELD ("Cod. Colegio"));
        }
        field(4; "Cod. Nivel"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"));
        }
        field(5; "Cod. Grado"; Code[20])
        {
            NotBlank = true;
        }
        field(6; "Cod. Turno"; Code[20])
        {
        }
        field(7; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE (Tipo = CONST (Vendedor));
        }
        field(8; "Cod. Producto"; Code[20])
        {
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            var
                DefDim: Record "Default Dimension";
                ConfAPS: Record "Commercial Setup";
            begin
                ConfAPS.Get();
                if ConfAPS."Cod. Dimension Serie" <> '' then begin
                    DefDim.Reset;
                    DefDim.SetRange("Table ID", 27);
                    DefDim.SetRange("No.", "Cod. Producto");
                    DefDim.SetRange("Dimension Code", ConfAPS."Cod. Dimension Serie");
                    if DefDim.FindFirst then
                        "Edicion Coleccion" := DefDim."Dimension Value Code";
                end;

                if ConfAPS."Cod. Dimension Lin. Negocio" <> '' then begin
                    DefDim.Reset;
                    DefDim.SetRange("Table ID", 27);
                    DefDim.SetRange("No.", "Cod. Producto");
                    DefDim.SetRange("Dimension Code", ConfAPS."Cod. Dimension Lin. Negocio");
                    if DefDim.FindFirst then
                        "Linea de negocio" := DefDim."Dimension Value Code";
                end;

                if ConfAPS."Cod. Dimension Familia" <> '' then begin
                    DefDim.Reset;
                    DefDim.SetRange("Table ID", 27);
                    DefDim.SetRange("No.", "Cod. Producto");
                    DefDim.SetRange("Dimension Code", ConfAPS."Cod. Dimension Familia");
                    if DefDim.FindFirst then
                        Familia := DefDim."Dimension Value Code";
                end;

                if ConfAPS."Cod. Dimension Sub Familia" <> '' then begin
                    DefDim.Reset;
                    DefDim.SetRange("Table ID", 27);
                    DefDim.SetRange("No.", "Cod. Producto");
                    DefDim.SetRange("Dimension Code", ConfAPS."Cod. Dimension Sub Familia");
                    if DefDim.FindFirst then
                        "Sub Familia" := DefDim."Dimension Value Code";
                end;
            end;
        }
        field(9; "Linea de negocio"; Code[20])
        {
        }
        field(10; Familia; Code[20])
        {
        }
        field(11; "Sub Familia"; Code[20])
        {
        }
        field(12; Serie; Code[20])
        {
        }
        field(13; "Adopcion - 2INI"; Option)
        {
            Caption = '2INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(14; "Marca Adopcion - 2INI"; Option)
        {
            Caption = 'CDS - 2INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(15; "Adopcion - 3INI"; Option)
        {
            Caption = '3INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(16; "Marca Adopcion - 3INI"; Option)
        {
            Caption = 'CDS - 3INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(17; "Adopcion - 4INI"; Option)
        {
            Caption = '4INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(18; "Marca Adopcion - 4INI"; Option)
        {
            Caption = 'CDS - 4INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(19; "Adopcion - 5INI"; Option)
        {
            Caption = '5INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(20; "Marca Adopcion - 5INI"; Option)
        {
            Caption = 'CDS - 5INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(21; "Adopcion - 1PRI"; Option)
        {
            Caption = '1PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(22; "Marca Adopcion - 1PRI"; Option)
        {
            Caption = 'CDS - 1PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(23; "Adopcion - 2PRI"; Option)
        {
            Caption = '2PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(24; "Marca Adopcion - 2PRI"; Option)
        {
            Caption = 'CDS - 2PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(25; "Adopcion - 3PRI"; Option)
        {
            Caption = '3PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(26; "Marca Adopcion - 3PRI"; Option)
        {
            Caption = 'CDS - 3PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(27; "Adopcion - 4PRI"; Option)
        {
            Caption = '4PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(28; "Marca Adopcion - 4PRI"; Option)
        {
            Caption = 'CDS - 4PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(29; "Adopcion - 5PRI"; Option)
        {
            Caption = '5PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(30; "Marca Adopcion - 5PRI"; Option)
        {
            Caption = 'CDS - 5PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(31; "Adopcion - 6PRI"; Option)
        {
            Caption = '6PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(32; "Marca Adopcion - 6PRI"; Option)
        {
            Caption = 'CDS - 6PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(33; "Adopcion - 1SEC"; Option)
        {
            Caption = '1SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(34; "Marca Adopcion - 1SEC"; Option)
        {
            Caption = 'CDS - 1SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(35; "Adopcion - 2SEC"; Option)
        {
            Caption = '2SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(36; "Marca Adopcion - 2SEC"; Option)
        {
            Caption = 'CDS - 2SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(37; "Adopcion - 3SEC"; Option)
        {
            Caption = '3SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(38; "Marca Adopcion - 3SEC"; Option)
        {
            Caption = 'CDS - 3SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(39; "Adopcion - 4SEC"; Option)
        {
            Caption = '4SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(40; "Marca Adopcion - 4SEC"; Option)
        {
            Caption = 'CDS - 4SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(41; "Adopcion - 5SEC"; Option)
        {
            Caption = '5SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(42; "Marca Adopcion - 5SEC"; Option)
        {
            Caption = 'CDS - 5SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(43; "Adopcion - 1SEI"; Option)
        {
            Caption = '1SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(44; "Marca Adopcion - 1SEI"; Option)
        {
            Caption = 'CDS - 1SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(45; "Adopcion - 2SEI"; Option)
        {
            Caption = '2SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(46; "Marca Adopcion - 2SEI"; Option)
        {
            Caption = 'CDS - 2SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(47; "Adopcion - 3SEI"; Option)
        {
            Caption = '3SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(48; "Marca Adopcion - 3SEI"; Option)
        {
            Caption = 'CDS - 3SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(49; "Adopcion - 4SEI"; Option)
        {
            Caption = '4SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(50; "Marca Adopcion - 4SEI"; Option)
        {
            Caption = 'CDS - 4SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(51; "Adopcion - 1VA"; Option)
        {
            Caption = '1VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(52; "Marca Adopcion - 1VA"; Option)
        {
            Caption = 'CDS - 1VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(53; "Adopcion - 2VA"; Option)
        {
            Caption = '2VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(54; "Marca Adopcion - 2VA"; Option)
        {
            Caption = 'CDS - 2VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(55; "Adopcion - 3VA"; Option)
        {
            Caption = '3VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(56; "Marca Adopcion - 3VA"; Option)
        {
            Caption = 'CDS - 3VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(58; "Adopcion - 4VA"; Option)
        {
            Caption = '4VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(59; "Marca Adopcion - 4VA"; Option)
        {
            Caption = 'CDS - 4VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(60; "Adopcion - 5VA"; Option)
        {
            Caption = '5VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(61; "Marca Adopcion - 5VA"; Option)
        {
            Caption = 'CDS - 5VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(62; "Grupo de negocio"; Code[20])
        {
        }
        field(63; "Cant. Presupuestada"; Integer)
        {
        }
        field(64; "2INI"; Code[10])
        {
            Caption = '2INI';
        }
        field(65; "3INI"; Code[10])
        {
            Caption = '3INI';
        }
        field(66; "4INI"; Code[10])
        {
            Caption = '4INI';
        }
        field(67; "5INI"; Code[10])
        {
            Caption = '5INI';
        }
        field(68; "1PRI"; Code[10])
        {
            Caption = '1PRI';
        }
        field(69; "2PRI"; Code[10])
        {
            Caption = '2PRI';
        }
        field(70; "3PRI"; Code[10])
        {
            Caption = '3PRI';
        }
        field(71; "4PRI"; Code[10])
        {
            Caption = '4PRI';
        }
        field(72; "5PRI"; Code[10])
        {
            Caption = '5PRI';
        }
        field(73; "6PRI"; Code[10])
        {
            Caption = '6PRI';
        }
        field(74; "1SEC"; Code[10])
        {
            Caption = '1SEC';
        }
        field(75; "2SEC"; Code[10])
        {
            Caption = '2SEC';
        }
        field(76; "3SEC"; Code[10])
        {
            Caption = '3SEC';
        }
        field(77; "4SEC"; Code[10])
        {
            Caption = '4SEC';
        }
        field(78; "5SEC"; Code[10])
        {
            Caption = '5SEC';
        }
        field(79; "1SEI"; Code[10])
        {
            Caption = '1SEI';
        }
        field(80; "2SEI"; Code[10])
        {
            Caption = '2SEI';
        }
        field(81; "3SEI"; Code[10])
        {
            Caption = '3SEI';
        }
        field(82; "4SEI"; Code[10])
        {
            Caption = '4SEI';
        }
        field(83; "1VA"; Code[10])
        {
            Caption = '1VA';
        }
        field(84; "2VA"; Code[10])
        {
            Caption = '2VA';
        }
        field(85; "3VA"; Code[10])
        {
            Caption = '3VA';
        }
        field(86; "4VA"; Code[10])
        {
            Caption = '4VA';
        }
        field(87; "5VA"; Code[10])
        {
            Caption = '5VA';
        }
        field(88; "Descripción producto"; Text[100])
        {
        }
        field(89; "Edicion Coleccion"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Docente", "Cod. Colegio", "Cod. Local", "Cod. Producto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

