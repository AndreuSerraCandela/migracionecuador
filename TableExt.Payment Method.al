tableextension 50047 tableextension50047 extends "Payment Method"
{
    fields
    {
        // modify("SAT Payment Method Code")
        // {
        //     Caption = 'Cód. forma pago SRI';
        //     Description = 'SANTINAV-6697';
        // }
        // modify("SAT Method of Payment")
        // {
        //     Caption = 'Forma pago SRI';
        //     Description = 'SANTINAV-6697';
        // }
        field(50000; "Cod. SRI"; Code[10])
        {
            Caption = 'Cód. SRI';
            DataClassification = ToBeClassified;
            Description = '#14564';
        }
        field(76042; "Forma de pago DGII"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            OptionCaption = ' ,1 - Efectivo,2 - Cheques/Transferencias/Depósitos,3 - Tarjeta Crédito/Debito,4 - Compra a crédito, 5 - Permuta,6 - Nota de crédito,7 - Mixto';
            OptionMembers = " ","1 - Efectivo","2 - Cheques/Transferencias/Depositos","3 - Tarjeta Credito/Debito","4 - Compra a credito"," 5 - Permuta","6 - Nota de credito","7 - Mixto";
        }
    }
}

