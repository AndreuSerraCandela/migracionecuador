#pragma implicitwith disable
page 76196 "Employee Capacity Matrix"
{
    ApplicationArea = all;
    Caption = 'Employee Shifts Matrix';
    Editable = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; rec."No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Full Name"; rec."Full Name")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a description of the resource.';
                }
                field(Field1; MATRIX_CellData[1])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(1)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(1);
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(2)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(2);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(3)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(3);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(4)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(4);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(5)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(5);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(6)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(6);
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(7)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(7);
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(8)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(8);
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(9)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(9);
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(10)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(10);
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(11)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(11);
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(12)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(12);
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(13)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(13);
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(14)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(14);
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(15)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(15);
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(16)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(16);
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(17)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(17);
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(18)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(18);
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(19)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(19);
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(20)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(20);
                    end;
                }
                field(Field21; MATRIX_CellData[21])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(21)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(21);
                    end;
                }
                field(Field22; MATRIX_CellData[22])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(22)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(22);
                    end;
                }
                field(Field23; MATRIX_CellData[23])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(23)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(23);
                    end;
                }
                field(Field24; MATRIX_CellData[24])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(24)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(24);
                    end;
                }
                field(Field25; MATRIX_CellData[25])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(25)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(25);
                    end;
                }
                field(Field26; MATRIX_CellData[26])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(26)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(26);
                    end;
                }
                field(Field27; MATRIX_CellData[27])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(27)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(27);
                    end;
                }
                field(Field28; MATRIX_CellData[28])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(28)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(28);
                    end;
                }
                field(Field29; MATRIX_CellData[29])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(29)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(29);
                    end;
                }
                field(Field30; MATRIX_CellData[30])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(30)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(30);
                    end;
                }
                field(Field31; MATRIX_CellData[31])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(31)
                    end;

                    trigger OnValidate()
                    begin
                        ValidateCapacity(31);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Resource")
            {
                Caption = '&Resource';
                Image = Resource;
                action(Card)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Ficha Empleados";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record on the document or journal line.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Resource),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(156),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                Image = Planning;
                action("&Set Capacity")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Set Capacity';
                    RunObject = Page "Resource Capacity Settings";
                    RunPageLink = "No." = FIELD("No.");
                    ToolTip = 'Change the capacity of the resource, such as a technician.';
                }
                action("Resource A&vailability")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource A&vailability';
                    Image = Calendar;
                    RunObject = Page "Resource Availability";
                    ToolTip = 'View a summary of resource capacities, the quantity of resource hours allocated to jobs on order, the quantity allocated to service orders, the capacity assigned to jobs on quote, and the resource availability.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        MATRIX_CurrentColumnOrdinal := 0;
        while MATRIX_CurrentColumnOrdinal < MATRIX_NoOfMatrixColumns do begin
            MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
        end;
    end;

    var
        MatrixRecords: array[32] of Record Date;
        QtyType: Option "Net Change","Balance at Date";
        MATRIX_NoOfMatrixColumns: Integer;
        MATRIX_CellData: array[31] of Text;
        MATRIX_ColumnCaption: array[31] of Text[1024];

    local procedure SetDateFilter(ColumnID: Integer)
    begin
        if QtyType = QtyType::"Net Change" then
            if MatrixRecords[ColumnID]."Period Start" = MatrixRecords[ColumnID]."Period End" then
                Rec.SetRange("Date Filter", MatrixRecords[ColumnID]."Period Start")
            else
                Rec.SetRange("Date Filter", MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period End")
        else
            Rec.SetRange("Date Filter", 0D, MatrixRecords[ColumnID]."Period End");
    end;

    local procedure MATRIX_OnAfterGetRecord(ColumnID: Integer)
    begin
        SetDateFilter(ColumnID);
        /*
        CALCFIELDS(Capacity);
        IF Capacity <> 0 THEN
          MATRIX_CellData[ColumnID] := Capacity
        ELSE
          MATRIX_CellData[ColumnID] := '';
        */

    end;


    procedure Load(QtyType1: Option "Net Change","Balance at Date"; MatrixColumns1: array[32] of Text[1024]; var MatrixRecords1: array[32] of Record Date; NoOfMatrixColumns1: Integer)
    var
        i: Integer;
    begin
        /*
        QtyType := QtyType1;
        COPYARRAY(MATRIX_ColumnCaption,MatrixColumns1,1);
        FOR i := 1 TO ARRAYLEN(MatrixRecords) DO
          MatrixRecords[i].COPY(MatrixRecords1[i]);
        MATRIX_NoOfMatrixColumns := NoOfMatrixColumns1;
        */

    end;

    local procedure MatrixOnDrillDown(ColumnID: Integer)
    var
        ResCapacityEntries: Record "Res. Capacity Entry";
    begin
        /*
        SetDateFilter(ColumnID);
        ResCapacityEntries.SETCURRENTKEY("Resource No.",Date);
        ResCapacityEntries.SETRANGE("Resource No.","No.");
        ResCapacityEntries.SETFILTER(Date,GETFILTER("Date Filter"));
        PAGE.RUN(0,ResCapacityEntries);
        */

    end;

    local procedure ValidateCapacity(MATRIX_ColumnOrdinal: Integer)
    begin
        /*SetDateFilter(MATRIX_ColumnOrdinal);
        CALCFIELDS(Capacity);
        VALIDATE(Capacity,MATRIX_CellData[MATRIX_ColumnOrdinal]);
        */

    end;
}

#pragma implicitwith restore

