table 76343 "Payroll Letters"
{
    Caption = 'Custom Report Layout';
    DrillDownPageID = "Custom Report Layouts";
    LookupPageID = "Custom Report Layouts";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'ID';
        }
        field(2; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));

            trigger OnValidate()
            begin

                if Code <> '' then begin
                    CRL.Reset;
                    CRL.SetRange(Code, Code);
                    CRL.FindFirst;
                    Description := CRL.Description;
                    "Report Name" := CRL."Report Name";
                end;
            end;
        }
        field(3; "Report Name"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("Report ID")));
            Caption = 'Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company;
        }
        field(6; Type; Option)
        {
            Caption = 'Type';
            InitValue = Word;
            OptionCaption = 'RDLC,Word';
            OptionMembers = RDLC,Word;
        }
        field(7; "Layout"; BLOB)
        {
            Caption = 'Layout';
        }
        field(8; "Last Modified"; DateTime)
        {
            Caption = 'Last Modified';
            Editable = false;
        }
        field(9; "Last Modified by User"; Code[50])
        {
            Caption = 'Last Modified by User';
            Editable = false;
        }
        field(10; "File Extension"; Text[30])
        {
            Caption = 'File Extension';
            Editable = false;
        }
        field(11; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(12; "Custom XML Part"; BLOB)
        {
            Caption = 'Custom XML Part';
        }
        field(13; Publish; Boolean)
        {
            Caption = 'Publish';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Report ID", "Company Name", Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField(Description);
        SetUpdated;
    end;

    trigger OnModify()
    begin
        TestField(Description);
        SetUpdated;
    end;

    var
        ImportWordTxt: Label 'Import Word Document';
        ImportRdlcTxt: Label 'Import Report Layout';
        FileFilterWordTxt: Label 'Word Files (*.docx)|*.docx', Comment = '{Split=r''\|''}{Locked=s''1''}';
        FileFilterRdlcTxt: Label 'SQL Report Builder (*.rdl;*.rdlc)|*.rdl;*.rdlc', Comment = '{Split=r''\|''}{Locked=s''1''}';
        NoRecordsErr: Label 'There is no record in the list.';
        BuiltInTxt: Label 'Built-in layout';
        CopyOfTxt: Label 'Copy of %1';
        NewLayoutTxt: Label 'New layout';
        ErrorInLayoutErr: Label 'Issue found in layout %1 for report ID  %2:\%3.', Comment = '%1=a name, %2=a number, %3=a sentence/error description.';
        TemplateValidationQst: Label 'The RDLC layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the layout validation:\%1\Do you want to continue?', Comment = '%1 = an error message.';
        TemplateValidationErr: Label 'The RDLC layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the document validation:\%1\You must update the layout to match the current report design.';
        AbortWithValidationErr: Label 'The RDLC layout action has been canceled because of validation errors.';
        CRL: Record "Custom Report Layout";

    local procedure SetUpdated()
    begin
        "Last Modified" := RoundDateTime(CurrentDateTime);
        "Last Modified by User" := UserId;
    end;


    procedure InitBuiltInLayout(ReportID: Integer; LayoutType: Option)
    var
        CustomReportLayout: Record "Custom Report Layout";
        DocumentReportMgt: Codeunit "Document Report Mgt.";
        InStr: InStream;
        OutStr: OutStream;
    begin
        /*IF ReportID = 0 THEN
          EXIT;
        CustomReportLayout.INIT;
        CustomReportLayout."Report ID" := ReportID;
        CustomReportLayout.Type := LayoutType;
        CustomReportLayout.Description := COPYSTR(STRSUBSTNO(CopyOfTxt,BuiltInTxt),1,MAXSTRLEN(Description));
        
        CASE LayoutType OF
          CustomReportLayout.Type::Word:
            BEGIN
              CustomReportLayout.Layout.CREATEOUTSTREAM(OutStr);
              IF NOT REPORT.WORDLAYOUT(ReportID,InStr) THEN BEGIN
                DocumentReportMgt.NewWordLayout(ReportID,OutStr);
                CustomReportLayout.Description := COPYSTR(NewLayoutTxt,1,MAXSTRLEN(Description));
              END ELSE
                COPYSTREAM(OutStr,InStr);
            END;
          CustomReportLayout.Type::RDLC:
            BEGIN
              CustomReportLayout.Layout.CREATEOUTSTREAM(OutStr);
              IF REPORT.RDLCLAYOUT(ReportID,InStr) THEN
                COPYSTREAM(OutStr,InStr);
            END;
        END;
        
        InsertCustomXmlPart(CustomReportLayout);
        
        CustomReportLayout.Code := 0;
        CustomReportLayout.INSERT(TRUE);
        */

    end;


    procedure InsertBuiltInLayout()
    var
        ReportLayoutLookup: Page "Report Layout Lookup";
        ReportID: Integer;
    begin
        FilterGroup(4);
        if GetFilter("Report ID") = '' then
            FilterGroup(0);
        if GetFilter("Report ID") <> '' then
            if Evaluate(ReportID, GetFilter("Report ID")) then
                ReportLayoutLookup.SetReportID(ReportID);
        FilterGroup(0);
        if ReportLayoutLookup.RunModal = ACTION::OK then begin
            if ReportLayoutLookup.SelectedAddWordLayot then
                InitBuiltInLayout(ReportLayoutLookup.SelectedReportID, Type::Word);
            if ReportLayoutLookup.SelectedAddRdlcLayot then
                InitBuiltInLayout(ReportLayoutLookup.SelectedReportID, Type::RDLC);
        end;
    end;


    procedure GetCustomRdlc(ReportID: Integer): Text
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        InStream: InStream;
        RdlcTxt: Text;
        CustomLayoutID: Integer;
    begin
        // Temporarily selected layout for Design-time report execution?
        /*IF ReportLayoutSelection.GetTempLayoutSelected <> 0 THEN
          CustomLayoutID := ReportLayoutSelection.GetTempLayoutSelected
        ELSE  // Normal selection
          IF ReportLayoutSelection.HasCustomLayout(ReportID) = 1 THEN
            CustomLayoutID := ReportLayoutSelection."Custom Report Layout Code";
        
        IF (CustomLayoutID <> 0) AND GET(CustomLayoutID) THEN BEGIN
          TESTFIELD(Type,Type::RDLC);
          CALCFIELDS(Layout);
          Layout.CREATEINSTREAM(InStream,TEXTENCODING::UTF8);
        END ELSE
          REPORT.RDLCLAYOUT(ReportID,InStream);
        InStream.READ(RdlcTxt);
        
        EXIT(RdlcTxt);
        */

    end;

    local procedure GetWordXML(var TempBlob: Codeunit "Temp Blob")
    var
        OutStr: OutStream;
    begin
        TestField("Report ID");
        TempBlob.CreateOutStream(OutStr, TEXTENCODING::UTF16);
        OutStr.WriteText(REPORT.WordXmlPart("Report ID"));
    end;


    procedure ExportSchema(DefaultFileName: Text; ShowFileDialog: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
    begin
        TestField(Type, Type::Word);

        if DefaultFileName = '' then
            DefaultFileName := '*.xml';

        GetWordXML(TempBlob);
        if TempBlob.HasValue then
            exit(FileMgt.BLOBExport(TempBlob, DefaultFileName, ShowFileDialog));
    end;


    procedure EditLayout()
    begin

        case Type of
            Type::Word:
                CODEUNIT.Run(CODEUNIT::"Custom Layout Reporting", Rec);
        end;
    end;

    local procedure GetFileExtension(): Text[4]
    begin
        case Type of
            Type::Word:
                exit('docx');
            Type::RDLC:
                exit('rdl');
        end;
    end;

    local procedure InsertCustomXmlPart(var CustomReportLayout: Record "Custom Report Layout")
    var
        OutStr: OutStream;
        WordXmlPart: Text;
    begin
        // Store the current design as an extended WordXmlPart. This data is used for later updates / refactorings.
        CustomReportLayout."Custom XML Part".CreateOutStream(OutStr, TEXTENCODING::UTF16);
        WordXmlPart := REPORT.WordXmlPart(CustomReportLayout."Report ID", true);
        if WordXmlPart <> '' then
            OutStr.Write(WordXmlPart);
    end;


    procedure GetCustomXmlPart() XmlPart: Text
    var
        InStr: InStream;
    begin
        CalcFields("Custom XML Part");
        if not "Custom XML Part".HasValue then
            exit;

        "Custom XML Part".CreateInStream(InStr, TEXTENCODING::UTF16);
        InStr.Read(XmlPart);
    end;


    procedure RunCustomReport(CodEmp: Code[20])
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        Emp: Record Employee;
    begin
        if "Report ID" = 0 then
            exit;

        Emp.SetRange("No.", CodEmp);

        ReportLayoutSelection.SetTempLayoutSelected(Code);
        REPORT.RunModal("Report ID", true, false, Emp);
        //ReportLayoutSelection.SetTempLayoutSelected('');
    end;
}

