tableextension 50138 tableextension50138 extends "Price List Line" //Sales Price
{
    fields
    {
        modify("VAT Bus. Posting Gr. (Price)")
        {
            Caption = 'Tax Bus. Posting Gr. (Price)';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        field(55000; "Cod. Oferta"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(55001; Location; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(55002; "Source counter"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(55003; "Precio manual"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(75000; IdJobQueueEntry; Guid)
        {
            DataClassification = ToBeClassified;
            Description = 'MdM , Id del Mov Cola de Proyecto relacionado';
        }
    }

    trigger OnInsert()
    begin
        // MdM 18/09/17
        if not wModificadoMdM then
            cGestMdm.GestNotityPrec(lwXRec2, Rec, false);
    end;

    trigger OnModify()
    begin
        if Rec."Asset Type" = Rec."Asset Type"::"Item" then
            cRep.Item("Product No.");

        // MdM 18/09/17
        if not wModificadoMdM then
            cGestMdm.GestNotityPrec(xRec, Rec, false);
    end;

    trigger OnDelete()
    begin
        // MdM 18/09/17
        if not wModificadoMdM then
            cGestMdm.GestNotityPrec(xRec, Rec, true);
    end;

    trigger OnRename()
    begin
        // MdM 18/09/17
        if not wModificadoMdM then
            cGestMdm.GestNotityPrec(xRec, Rec, false);
    end;



    procedure SetModificadoMdM(prMod: Boolean)
    begin
        // SetModificadoMdM
        //  MdM Indicamos que ha sido modificado por MdM

        wModificadoMdM := prMod;
    end;

    var
        lwXRec2: Record "Price List Line";

    var
        cRep: Codeunit "Funciones Replicador DsPOS";
        cGestMdm: Codeunit "Gest. Maestros MdM";
        wModificadoMdM: Boolean;
}

