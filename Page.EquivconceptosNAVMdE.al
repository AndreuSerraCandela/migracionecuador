#pragma implicitwith disable
page 56200 "Equiv. conceptos NAV-MdE"
{
    ApplicationArea = all;

    Caption = 'Equiv. NAV-MdE concepts';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Show';
    SourceTable = "Conceptos salariales";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            fixed("Tipo dato MdE")
            {
                Caption = 'Tipo dato MdE';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                /*           field(GetMdEEquiv; rec.GetMdEEquiv)
                          {
                              Editable = false;
                              Enabled = false;
                              Importance = Promoted;
                          } */
            }
            repeater(Group)
            {
                FreezeColumn = Descripcion;
                field(Codigo; rec.Codigo)
                {
                    Editable = false;
                }
                field(Descripcion; rec.Descripcion)
                {
                    Editable = false;
                }
                field("BooleanArray[1]"; BooleanArray[1])
                {
                    CaptionClass = ColumnNameArray[1];
                    Visible = NoColumns > 0;

                    trigger OnValidate()
                    begin
                        ValidateColumn(1);
                    end;
                }
                field("BooleanArray[2]"; BooleanArray[2])
                {
                    CaptionClass = ColumnNameArray[2];
                    Visible = NoColumns > 1;

                    trigger OnValidate()
                    begin
                        ValidateColumn(2);
                    end;
                }
                field("BooleanArray[3]"; BooleanArray[3])
                {
                    CaptionClass = ColumnNameArray[3];
                    Visible = NoColumns > 2;

                    trigger OnValidate()
                    begin
                        ValidateColumn(3);
                    end;
                }
                field("BooleanArray[4]"; BooleanArray[4])
                {
                    CaptionClass = ColumnNameArray[4];
                    Visible = NoColumns > 3;

                    trigger OnValidate()
                    begin
                        ValidateColumn(4);
                    end;
                }
                field("BooleanArray[5]"; BooleanArray[5])
                {
                    CaptionClass = ColumnNameArray[5];
                    Visible = NoColumns > 4;

                    trigger OnValidate()
                    begin
                        ValidateColumn(5);
                    end;
                }
                field("BooleanArray[6]"; BooleanArray[6])
                {
                    CaptionClass = ColumnNameArray[6];
                    Visible = NoColumns > 5;

                    trigger OnValidate()
                    begin
                        ValidateColumn(6);
                    end;
                }
                field("BooleanArray[7]"; BooleanArray[7])
                {
                    CaptionClass = ColumnNameArray[7];
                    Visible = NoColumns > 6;

                    trigger OnValidate()
                    begin
                        ValidateColumn(7);
                    end;
                }
                field("BooleanArray[8]"; BooleanArray[8])
                {
                    CaptionClass = ColumnNameArray[8];
                    Visible = NoColumns > 7;

                    trigger OnValidate()
                    begin
                        ValidateColumn(8);
                    end;
                }
                field("BooleanArray[9]"; BooleanArray[9])
                {
                    CaptionClass = ColumnNameArray[9];
                    Visible = NoColumns > 8;

                    trigger OnValidate()
                    begin
                        ValidateColumn(9);
                    end;
                }
                field("BooleanArray[10]"; BooleanArray[10])
                {
                    CaptionClass = ColumnNameArray[10];
                    Visible = NoColumns > 9;

                    trigger OnValidate()
                    begin
                        ValidateColumn(10);
                    end;
                }
                field("BooleanArray[11]"; BooleanArray[11])
                {
                    CaptionClass = ColumnNameArray[11];
                    Visible = NoColumns > 10;

                    trigger OnValidate()
                    begin
                        ValidateColumn(11);
                    end;
                }
                field("BooleanArray[12]"; BooleanArray[12])
                {
                    CaptionClass = ColumnNameArray[12];
                    Visible = NoColumns > 11;

                    trigger OnValidate()
                    begin
                        ValidateColumn(12);
                    end;
                }
                field("BooleanArray[13]"; BooleanArray[13])
                {
                    CaptionClass = ColumnNameArray[13];
                    Visible = NoColumns > 12;

                    trigger OnValidate()
                    begin
                        ValidateColumn(13);
                    end;
                }
                field("BooleanArray[14]"; BooleanArray[14])
                {
                    CaptionClass = ColumnNameArray[14];
                    Visible = NoColumns > 13;

                    trigger OnValidate()
                    begin
                        ValidateColumn(14);
                    end;
                }
                field("BooleanArray[15]"; BooleanArray[15])
                {
                    CaptionClass = ColumnNameArray[15];
                    Visible = NoColumns > 14;

                    trigger OnValidate()
                    begin
                        ValidateColumn(15);
                    end;
                }
                field("BooleanArray[16]"; BooleanArray[16])
                {
                    CaptionClass = ColumnNameArray[16];
                    Visible = NoColumns > 15;

                    trigger OnValidate()
                    begin
                        ValidateColumn(16);
                    end;
                }
                field("BooleanArray[17]"; BooleanArray[17])
                {
                    CaptionClass = ColumnNameArray[17];
                    Visible = NoColumns > 16;

                    trigger OnValidate()
                    begin
                        ValidateColumn(17);
                    end;
                }
                field("BooleanArray[18]"; BooleanArray[18])
                {
                    CaptionClass = ColumnNameArray[18];
                    Visible = NoColumns > 17;

                    trigger OnValidate()
                    begin
                        ValidateColumn(18);
                    end;
                }
                field("BooleanArray[19]"; BooleanArray[19])
                {
                    CaptionClass = ColumnNameArray[19];
                    Visible = NoColumns > 18;

                    trigger OnValidate()
                    begin
                        ValidateColumn(19);
                    end;
                }
                field("BooleanArray[20]"; BooleanArray[20])
                {
                    CaptionClass = ColumnNameArray[20];
                    Visible = NoColumns > 19;

                    trigger OnValidate()
                    begin
                        ValidateColumn(20);
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Información Real Mensual")
            {
                Enabled = MdEDataType = 1;
                Image = CompleteLine;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MdEDataType := MdEDataType::IRM;
                    SetNoColumns;
                end;
            }
            action("Compensación Teórica")
            {
                Enabled = MdEDataType = 0;
                Image = CompleteLine;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MdEDataType := MdEDataType::CT;
                    SetNoColumns;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        i: Integer;
    begin
        for i := 1 to NoColumns do begin
            if MdEDataType = MdEDataType::IRM then
                BooleanArray[i] := EquivNavMdE.Get(Rec.Codigo, i, 0) and (EquivNavMdE.Porcentaje > 0)
            else
                BooleanArray[i] := EquivNavMdE.Get(Rec.Codigo, 0, i) and (EquivNavMdE.Porcentaje > 0)
        end;
    end;

    trigger OnOpenPage()
    begin
        SetNoColumns;
    end;

    var
        EquivNavMdE: Record "Equiv. conceptos NAV-MdE";
        BooleanArray: array[20] of Boolean;
        ColumnNameArray: array[20] of Text[20];
        NoColumns: Integer;
        MdEDataType: Option IRM,CT;
        Text000: Label 'Información Real Mensual';
        Text001: Label 'Compensación Teórica';


    procedure SetNoColumns()
    var
        i: Integer;
    begin
        Clear(ColumnNameArray);
        NoColumns := EquivNavMdE.GetNoConcepts(MdEDataType);
        for i := 1 to NoColumns do begin
            if MdEDataType = MdEDataType::IRM then begin
                EquivNavMdE."Concepto IRM" := i;
                ColumnNameArray[i] := StrSubstNo('%1', EquivNavMdE."Concepto IRM");
            end
            else begin
                EquivNavMdE."Concepto CT" := i;
                ColumnNameArray[i] := StrSubstNo('%1', EquivNavMdE."Concepto CT");
            end;
        end;
        CurrPage.Update(false);
    end;


    procedure ValidateColumn(Column: Integer)
    var
        IrmVal: Integer;
        CtVal: Integer;
    begin
        if MdEDataType = MdEDataType::IRM then
            IrmVal := Column
        else
            CtVal := Column;

        if BooleanArray[Column] then begin
            if EquivNavMdE.Get(Rec.Codigo, IrmVal, CtVal) then begin
                EquivNavMdE.Porcentaje := 1;
                EquivNavMdE.Modify;
            end
            else begin
                EquivNavMdE."Concepto NAV" := Rec.Codigo;
                EquivNavMdE."Concepto IRM" := IrmVal;
                EquivNavMdE."Concepto CT" := CtVal;
                EquivNavMdE.Porcentaje := 1;
                EquivNavMdE.Insert;
            end
        end
        else begin
            if EquivNavMdE.Get(Rec.Codigo, IrmVal, CtVal) then
                EquivNavMdE.Delete;
        end;
    end;


    procedure GetMdEEquiv(): Text[50]
    begin
        if MdEDataType = MdEDataType::IRM then
            exit(Text000)
        else
            exit(Text001);
    end;
}

#pragma implicitwith restore

