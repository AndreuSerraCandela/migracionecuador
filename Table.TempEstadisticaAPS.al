table 76321 "Temp Estadistica APS"
{
    DrillDownPageID = "Promotores - Ppto Vtas";
    LookupPageID = "Promotores - Ppto Vtas";

    fields
    {
        field(1; "Cod. Editorial"; Code[20])
        {
            NotBlank = true;
            TableRelation = Editoras;
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
        field(13; "Cantidad - 2INI"; Decimal)
        {
            Caption = '2INI';
            DecimalPlaces = 0 : 0;
        }
        field(14; "Adopcion - 2INI"; Option)
        {
            Caption = '2INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(15; "Cantidad - 3INI"; Decimal)
        {
            Caption = '3INI';
            DecimalPlaces = 0 : 0;
        }
        field(16; "Adopcion - 3INI"; Option)
        {
            Caption = '3INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(17; "Cantidad - 4INI"; Decimal)
        {
            Caption = '4INI';
            DecimalPlaces = 0 : 0;
        }
        field(18; "Adopcion - 4INI"; Option)
        {
            Caption = '4INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(19; "Cantidad - 5INI"; Decimal)
        {
            Caption = '5INI';
            DecimalPlaces = 0 : 0;
        }
        field(20; "Adopcion - 5INI"; Option)
        {
            Caption = '5INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(21; "Cantidad - 1PRI"; Decimal)
        {
            Caption = '1PRI';
            DecimalPlaces = 0 : 0;
        }
        field(22; "Adopcion - 1PRI"; Option)
        {
            Caption = '1PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(23; "Cantidad - 2PRI"; Decimal)
        {
            Caption = '2PRI';
            DecimalPlaces = 0 : 0;
        }
        field(24; "Adopcion - 2PRI"; Option)
        {
            Caption = '2PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(25; "Cantidad - 3PRI"; Decimal)
        {
            Caption = '3PRI';
            DecimalPlaces = 0 : 0;
        }
        field(26; "Adopcion - 3PRI"; Option)
        {
            Caption = '3PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(27; "Cantidad - 4PRI"; Decimal)
        {
            Caption = '4PRI';
            DecimalPlaces = 0 : 0;
        }
        field(28; "Adopcion - 4PRI"; Option)
        {
            Caption = '4PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(29; "Cantidad - 5PRI"; Decimal)
        {
            Caption = '5PRI';
            DecimalPlaces = 0 : 0;
        }
        field(30; "Adopcion - 5PRI"; Option)
        {
            Caption = '5PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(31; "Cantidad - 6PRI"; Decimal)
        {
            Caption = '6PRI';
            DecimalPlaces = 0 : 0;
        }
        field(32; "Adopcion - 6PRI"; Option)
        {
            Caption = '6PRI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(33; "Cantidad - 1SEC"; Decimal)
        {
            Caption = '1SEC';
            DecimalPlaces = 0 : 0;
        }
        field(34; "Adopcion - 1SEC"; Option)
        {
            Caption = '1SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(35; "Cantidad - 2SEC"; Decimal)
        {
            Caption = '2SEC';
            DecimalPlaces = 0 : 0;
        }
        field(36; "Adopcion - 2SEC"; Option)
        {
            Caption = '2SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(37; "Cantidad - 3SEC"; Decimal)
        {
            Caption = '3SEC';
            DecimalPlaces = 0 : 0;
        }
        field(38; "Adopcion - 3SEC"; Option)
        {
            Caption = '3SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(39; "Cantidad - 4SEC"; Decimal)
        {
            Caption = '4SEC';
            DecimalPlaces = 0 : 0;
        }
        field(40; "Adopcion - 4SEC"; Option)
        {
            Caption = '4SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(41; "Cantidad - 5SEC"; Decimal)
        {
            Caption = '5SEC';
            DecimalPlaces = 0 : 0;
        }
        field(42; "Adopcion - 5SEC"; Option)
        {
            Caption = '5SEC';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(43; "Cantidad - 1SEI"; Decimal)
        {
            Caption = '1SEI';
            DecimalPlaces = 0 : 0;
        }
        field(44; "Adopcion - 1SEI"; Option)
        {
            Caption = '1SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(45; "Cantidad - 2SEI"; Decimal)
        {
            Caption = '2SEI';
            DecimalPlaces = 0 : 0;
        }
        field(46; "Adopcion - 2SEI"; Option)
        {
            Caption = '2SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(47; "Cantidad - 3SEI"; Decimal)
        {
            Caption = '3SEI';
            DecimalPlaces = 0 : 0;
        }
        field(48; "Adopcion - 3SEI"; Option)
        {
            Caption = '3SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(49; "Cantidad - 4SEI"; Decimal)
        {
            Caption = '4SEI';
            DecimalPlaces = 0 : 0;
        }
        field(50; "Adopcion - 4SEI"; Option)
        {
            Caption = '4SEI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(51; "Cantidad - 1VA"; Decimal)
        {
            Caption = '1VA';
            DecimalPlaces = 0 : 0;
        }
        field(52; "Adopcion - 1VA"; Option)
        {
            Caption = '1VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(53; "Cantidad - 2VA"; Decimal)
        {
            Caption = '2VA';
            DecimalPlaces = 0 : 0;
        }
        field(54; "Adopcion - 2VA"; Option)
        {
            Caption = '2VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(55; "Cantidad - 3VA"; Decimal)
        {
            Caption = '3VA';
            DecimalPlaces = 0 : 0;
        }
        field(56; "Adopcion - 3VA"; Option)
        {
            Caption = '3VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(57; "Cantidad - 4VA"; Decimal)
        {
            Caption = '4VA';
            DecimalPlaces = 0 : 0;
        }
        field(58; "Adopcion - 4VA"; Option)
        {
            Caption = '4VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(59; "Cantidad - 5VA"; Decimal)
        {
            Caption = '5VA';
            DecimalPlaces = 0 : 0;
        }
        field(60; "Adopcion - 5VA"; Option)
        {
            Caption = '5VA';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(61; "Grupo de negocio"; Code[20])
        {
        }
        field(62; "Cant. Presupuestada"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Sub Familia")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

