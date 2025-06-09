tableextension 50126 tableextension50126 extends "Service Header"
{
    fields
    {
        modify("Your Reference")
        {
            Caption = 'Customer PO No.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }

        //Unsupported feature: Code Modification on ""Ship-to Code"(Field 12).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if ("Ship-to Code" <> xRec."Ship-to Code") and
           ("Customer No." = xRec."Customer No.")
        then begin
        #4..75
        Validate("Service Zone Code");

        if ("Ship-to Code" <> xRec."Ship-to Code") and
           ("Customer No." = xRec."Customer No.") and
           ServItemLineExists
        then begin
          Modify(true);
          ServLine.LockTable;
        #84..90
          ServItemLine.SetRange("Document No.","No.");
          ServItemLine.DeleteAll(true);
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..78
           ("Customer No." = xRec."Customer No.")
        #81..93
        */
        //end;

        //Unsupported feature: Deletion (FieldCollection) on ""CFDI Export Code"(Field 27004)".

        field(76041; "No. Serie NCF Facturas"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.02';
            TableRelation = "No. Series";
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.02';
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.02';
        }
        field(76056; "Razon anulacion NCF"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.02';
            TableRelation = "No. Series";
        }
        field(76057; "No. Serie NCF Abonos"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.02';
            TableRelation = "No. Series";
        }
        field(76078; "Cod. Clasificacion Gasto"; Code[2])
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.02';
        }
        field(76058; "Fecha vencimiento NCF"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76007; "Tipo de ingreso"; Code[2])
        {
            Caption = 'Income type';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            InitValue = '01';
            TableRelation = "Tipos de ingresos";
        }
    }


    //Unsupported feature: Code Modification on "RecreateServLines(PROCEDURE 2)".

    //procedure RecreateServLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if ServLineExists then begin
      if HideValidationDialog then
        Confirmed := true
    #4..39
                TempServDocReg.Insert;
              until ServDocReg.Next = 0;
          end;
          StoreServiceCommentLineToTemp(TempServiceCommentLine);
          ServiceCommentLine.DeleteComments(ServiceCommentLine."Table Name"::"Service Header","Document Type","No.");
          ServLine.DeleteAll(true);

          if "Document Type" = "Document Type"::Invoice then begin
    #48..51
              until TempServDocReg.Next = 0;
          end;

          CreateServiceLines(TempServLine,ExtendedTextAdded,TempServiceCommentLine);
          TempServLine.SetRange(Type);
          TempServLine.DeleteAll;
        end;
      end else
        Error('');
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..42
    #45..54
          CreateServiceLines(TempServLine,ExtendedTextAdded);
    #56..61
    */
    //end;


    //Unsupported feature: Code Modification on "CreateServiceLines(PROCEDURE 50)".

    //procedure CreateServiceLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ServLine.Init;
    ServLine."Line No." := 0;
    TempServLine.Find('-');
    #4..70
          ServLine.Find('+');
          ExtendedTextAdded := true;
        end;
      RestoreServiceCommentLine(TempServiceCommentLine,TempServLine."Line No.",ServLine."Line No.");
      CopyReservEntryFromTemp(TempServLine,ServLine."Line No.");
    until TempServLine.Next = 0;
    RestoreServiceCommentLine(TempServiceCommentLine,0,0);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..73
      CopyReservEntryFromTemp(TempServLine,ServLine."Line No.");
    until TempServLine.Next = 0;
    */
    //end;


    //Unsupported feature: Code Modification on "CopyCFDIFieldsFromCustomer(PROCEDURE 1310000)".

    //procedure CopyCFDIFieldsFromCustomer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if Customer.Get("Bill-to Customer No.") then begin
      "CFDI Purpose" := Customer."CFDI Purpose";
      "CFDI Relation" := Customer."CFDI Relation";
      "CFDI Export Code" := Customer."CFDI Export Code";
    end else begin
      "CFDI Purpose" := '';
      "CFDI Relation" := '';
      "CFDI Export Code" := '';
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    #5..7
    end;
    */
    //end;

    //Unsupported feature: Deletion (VariableCollection) on "RecreateServLines(PROCEDURE 2).ServiceCommentLine(Variable 1007)".


    //Unsupported feature: Deletion (VariableCollection) on "RecreateServLines(PROCEDURE 2).TempServiceCommentLine(Variable 1006)".


    //Unsupported feature: Deletion (ParameterCollection) on "CreateServiceLines(PROCEDURE 50).TempServiceCommentLine(Parameter 1002)".

    //>>>> MODIFIED VALUE:
    //Text013 : ENU=Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?;ESM=Si elimina el documento, se provocará una discontinuidad en la numeración de la serie de notas de crédito registradas. Se creará un nota crédito regis. en blanco %1 para completar este error en las series numéricas.\\¿Desea continuar?;FRC=La suppression de ce document va engendrer un écart dans la série de numéros d'avoirs reportés. Un avoir reporté vide %1 va être créé pour éviter un écart dans la série de numéros.\\Voulez-vous continuer ?;ENC=Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?;
    //Variable type has not been exported.

}

