tableextension 50046 tableextension50046 extends "Vendor Bank Account"
{
    fields
    {
        field(55000; "Tipo Cuenta"; Option)
        {
            Caption = 'Account type';
            DataClassification = ToBeClassified;
            OptionCaption = 'CTE= Cuenta Corriente,AHO=Cuenta de Ahorro,CON=Contable,TJ= Tarjeta,PR= Préstamos';
            OptionMembers = "CC= Cuenta Corriente","CA=Cuenta de Ahorro","TJ= Tarjeta","PR= Préstamos";
        }
        field(55001; "Banco Receptor"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bancos ACH Nomina";
        }
    }
}

