pageextension 50100 pageextension50100 extends "Item Reference Entries"
{
    layout
    {
        modify(Control1)
        {
            Editable = wEditable;
        }
        modify("Reference Type")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                // <MdM>
                if Rec."Reference Type" = Rec."Reference Type"::"Bar Code" then
                    cFunMdm.GetEditableErr(Rec.TableCaption);
                // <\MdM>
            end;
        }
        addafter("Reference Type")
        {
            field("Item No."; rec."Item No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Description 2")
        {
            label("Descripción Producto") //No existe el campo
            {
                Caption = 'Descripción Producto';
                ApplicationArea = Basic, Suite;
                //TableRelation = Item.Description; //Validar por que hay una tabla en un label
            }
        }
    }

    var
        cFunMdm: Codeunit "Funciones MdM";
        wEditable: Boolean;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        GetEditable; // MdM
    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        // <MdM>
        if Rec."Reference Type" = Rec."Reference Type"::"Bar Code" then
            cFunMdm.GetEditableErr(Rec.TableCaption);
        GetEditable;
        // <\MdM>
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        // <MdM>
        if Rec."Reference Type" = Rec."Reference Type"::"Bar Code" then
            cFunMdm.GetEditableErr(Rec.TableCaption);
        GetEditable;
        // <\MdM>
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        // <MdM>
        if Rec."Reference Type" = Rec."Reference Type"::"Bar Code" then
            cFunMdm.GetEditableErr(Rec.TableCaption);
        GetEditable;
        // <\MdM>
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        wEditable := true; // MdM
    end;

    procedure GetEditable(): Boolean
    begin
        // IsEditable
        // MdM

        if rec."Reference Type" = rec."Reference Type"::"Bar Code" then
            wEditable := cFunMdm.GetEditable
        else
            wEditable := true;

        CurrPage.Editable := wEditable;
        exit(wEditable)
    end;
}

