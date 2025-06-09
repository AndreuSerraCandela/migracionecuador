table 56032 "Contenido Cajas Packing"
{
    // #842 04/02/13 CAT. Nuevo campo (de tipo calculado) No. Palet

    Caption = 'Packing Box Content';
    Permissions = TableData "Registered Whse. Activity Line" = rimd;

    fields
    {
        field(1; "No. Packing"; Code[20])
        {
        }
        field(2; "No. Caja"; Code[20])
        {
            Caption = 'Box No.';
        }
        field(3; "No. Producto"; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
        }
        field(4; Descripcion; Text[200])
        {
            Caption = 'Description';
        }
        field(5; "No. Linea"; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Cod. Barras"; Code[30])
        {
            Caption = 'Barcode';

            trigger OnValidate()
            begin
                //Codigo de barras
                if (StrLen(Format("Cod. Barras"))) > 5 then begin
                    ICR.Reset;
                    ICR.SetRange("Reference Type", ICR."Reference Type"::"Bar Code");
                    ICR.SetRange(ICR."Reference No.", "Cod. Barras");
                    if ICR.FindFirst then
                      //se localiza el producto en a linea de picking registrado
                      begin
                        RWAL.Reset;
                        RWAL.SetRange(RWAL."Activity Type", RWAL."Activity Type"::Pick);
                        RWAL.SetRange(RWAL."No.", "No. Picking");
                        RWAL.SetRange(RWAL."Item No.", ICR."Item No.");
                        RWAL.SetRange(RWAL."Action Type", RWAL."Action Type"::Take);
                        if RWAL.FindFirst then begin
                            "No. Producto" := RWAL."Item No.";
                            //Cantidad := RWAL.Quantity;
                            "Cod. Unidad de Medida" := RWAL."Unit of Measure Code";
                            Descripcion := RWAL.Description;
                            "No. Linea Picking" := RWAL."Line No.";
                            RWAL1.Get(RWAL."Activity Type", RWAL."No.", RWAL."Line No.");
                            RWAL1.Validate("No. Packing", "No. Packing");
                            RWAL1.Validate("No. Caja", "No. Caja");
                            //RWAL1.VALIDATE("No. Linea Packing","No. Linea");
                            RWAL1.Modify(true);
                        end
                        else
                            Error(Errorr003, ICR."Item No.", "No. Picking");

                    end
                    else
                        Message(txt001);
                end
                else begin
                    if RWAL.Get(RWAL."Activity Type"::Pick, "No. Picking", "No. Linea Picking") then begin
                        //Se calcula la cantidad del producto que est'a incluida en otras cajas
                        CCP.Reset;
                        CCP.SetRange("No. Packing", "No. Packing");
                        //CCP.SETRANGE("No. Caja","No. Caja");
                        CCP.SetRange("No. Producto", "No. Producto");
                        CCP.SetFilter("No. Linea", '<>%1', "No. Linea");
                        if CCP.FindSet then
                            repeat
                                wCant1 += CCP.Cantidad;
                            until CCP.Next = 0;
                        Evaluate(wCant, "Cod. Barras");

                        if RWAL.Quantity < (wCant1 + wCant) then
                            Error(Error001);
                    end;
                    Evaluate(Cantidad, "Cod. Barras");
                end;
            end;
        }
        field(7; "Cod. Unidad de Medida"; Code[20])
        {
            Caption = 'Unit Of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE ("Item No." = FIELD ("No. Producto"));
        }
        field(8; Cantidad; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                /*
                //Se buscan las lineas del Picking con el producto actual
                wCant1 := 0;
                CLEAR(RWAL);
                RWAL.SETRANGE("Activity Type",RWAL."Activity Type"::Pick);
                RWAL.SETRANGE("No.","No. Picking");
                RWAL.SETRANGE("Item No.","No. Producto");
                RWAL.SETRANGE("Action Type",RWAL."Action Type"::Take);
                IF RWAL.FINDSET THEN
                  REPEAT
                    wCant1 += RWAL.Quantity - RWAL."Cantidad Empacada";
                  UNTIL RWAL.NEXT = 0;
                IF Cantidad > wCant1 THEN
                  ERROR(txt002,FORMAT(Cantidad),RWAL."No.");
                
                
                CLEAR(RWAL);
                RWAL.SETRANGE("Activity Type",RWAL."Activity Type"::Pick);
                RWAL.SETRANGE("No.","No. Picking");
                RWAL.SETRANGE("Item No.","No. Producto");
                RWAL.SETRANGE("Action Type",RWAL."Action Type"::Take);
                IF RWAL.FINDSET THEN
                  BEGIN
                    wCant := Cantidad;
                   { IF Cantidad = 0 THEN
                      BEGIN
                        RWAL."Cantidad Empacada" := 0;
                        RWAL.VALIDATE("No. Packing",'');
                        RWAL.VALIDATE("No. Caja",'');
                        RWAL.VALIDATE("No. Linea Packing",0);
                        RWAL.MODIFY;
                      END
                    ELSE
                    }
                      REPEAT
                        IF (RWAL.Quantity - RWAL."Cantidad Empacada" > 0) AND (wCant > 0) THEN
                          BEGIN
                            IF wCant >= (RWAL.Quantity - RWAL."Cantidad Empacada") THEN
                              BEGIN
                                CantFaltante := RWAL.Quantity - RWAL."Cantidad Empacada";
                                RWAL."Cantidad Empacada" += (CantFaltante);
                                wCant := wCant - CantFaltante;
                                "No. Producto" := RWAL."Item No.";
                                "Cod. Unidad de Medida" := RWAL."Unit of Measure Code";
                                Descripcion := RWAL.Description;
                                //"No. Linea Picking" := RWAL."Line No.";
                                RWAL.VALIDATE("No. Packing","No. Packing");
                                RWAL.VALIDATE("No. Caja","No. Caja");
                                RWAL.VALIDATE("No. Linea Packing","No. Linea");
                                RWAL.MODIFY(TRUE);
                              END
                            ELSE
                              BEGIN
                                RWAL."Cantidad Empacada" += wCant;
                                wCant := wCant - RWAL."Cantidad Empacada";
                                "No. Producto" := RWAL."Item No.";
                                "Cod. Unidad de Medida" := RWAL."Unit of Measure Code";
                                Descripcion := RWAL.Description;
                                //"No. Linea Picking" := RWAL."Line No.";
                                RWAL.VALIDATE("No. Packing","No. Packing");
                                RWAL.VALIDATE("No. Caja","No. Caja");
                                RWAL.VALIDATE("No. Linea Packing","No. Linea");
                                RWAL.MODIFY(TRUE);
                              END;
                          END;
                      UNTIL RWAL.NEXT = 0;
                  END;
                
                {
                TESTFIELD("No. Linea Picking");
                IF RWAL.GET(RWAL."Activity Type"::Pick,"No. Picking","No. Linea Picking") THEN
                  BEGIN
                    //Se calcula la cantidad del producto que est'a incluida en otras cajas
                    CCP.RESET;
                    CCP.SETRANGE("No. Packing","No. Packing");
                    CCP.SETRANGE("No. Producto","No. Producto");
                    CCP.SETFILTER("No. Linea",'<>%1',"No. Linea");
                    CCP.SETRANGE(CCP."No. Linea Picking","No. Linea Picking");
                    IF CCP.FINDSET THEN
                      REPEAT
                        wCant1 += CCP.Cantidad;
                      UNTIL CCP.NEXT = 0;
                    wCant := Cantidad;
                
                    IF RWAL.Quantity < (wCant1 + wCant) THEN
                      ERROR(Error001);
                  END;
                }
                */

            end;
        }
        field(9; "No. Picking"; Code[20])
        {
            Caption = 'Picking No';
        }
        field(10; "No. Linea Picking"; Integer)
        {
            Caption = 'Picking Line No.';
            NotBlank = true;
            TableRelation = "Registered Whse. Activity Line"."Line No." WHERE ("Activity Type" = FILTER (Pick),
                                                                               "No." = FIELD ("No. Picking"),
                                                                               "Action Type" = FILTER (Take));

            trigger OnValidate()
            begin
                if RWAL.Get(RWAL."Activity Type"::Pick, "No. Picking", "No. Linea Picking") then begin
                    "No. Producto" := RWAL."Item No.";
                    //Cantidad := RWAL.Quantity;
                    "Cod. Unidad de Medida" := RWAL."Unit of Measure Code";
                    Descripcion := RWAL.Description;
                    "No. Linea Picking" := RWAL."Line No.";
                    RWAL.Validate("No. Packing", "No. Packing");
                    RWAL.Validate("No. Caja", "No. Caja");
                    // RWAL.VALIDATE("No. Linea Packing","No. Linea");
                    RWAL.Modify(true);
                end;
            end;
        }
        field(11; "Peso Calculado"; Decimal)
        {
            Caption = 'Calculated weight';
        }
        field(12; "Peso de la Caja"; Decimal)
        {
            Caption = 'Calculated weight';
        }
        field(13; "Peso real"; Decimal)
        {
            Caption = 'Real weight';
        }
        field(14; Diferencia; Decimal)
        {
            Caption = 'Diference';
        }
        field(15; "Serie de etiquetas"; Code[20])
        {
            Caption = 'Tag Series';
        }
        field(16; "No. Palet"; Code[20])
        {
            CalcFormula = Lookup ("Lin. Packing"."No. Palet" WHERE ("No." = FIELD ("No. Packing"),
                                                                   "No. Caja" = FIELD ("No. Caja")));
            Description = '#842';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No. Packing", "No. Caja", "No. Picking", "No. Producto", "No. Linea")
        {
            Clustered = true;
            SumIndexFields = Cantidad;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if LinPack.Get("No. Packing", "No. Caja") then
            LinPack.TestField("Estado Caja", LinPack."Estado Caja"::Abierta);

        /*
        IF RWAL.GET(RWAL."Activity Type"::Pick,"No. Picking","No. Linea Picking") THEN
          BEGIN
            RWAL.VALIDATE("No. Packing",'');
            RWAL.VALIDATE("No. Caja",'');
            RWAL.VALIDATE("No. Linea Packing",0);
            RWAL.MODIFY(TRUE);
          END;
        
        RWAL.RESET;
        RWAL.SETRANGE("Activity Type",RWAL."Activity Type"::Pick);
        RWAL.SETRANGE("No.","No. Picking");
        RWAL.SETRANGE("No. Packing","No. Packing");
        RWAL.SETRANGE("No. Caja","No. Caja");
        RWAL.SETRANGE("No. Linea Packing","No. Linea");
        IF RWAL.FINDSET THEN
          REPEAT
            RWAL.VALIDATE("No. Packing",'');
            RWAL.VALIDATE("No. Caja",'');
            RWAL.VALIDATE("No. Linea Packing",0);
            RWAL."Cantidad Empacada" := 0;
            RWAL.MODIFY(TRUE);
          UNTIL RWAL.NEXT = 0;
        */

    end;

    trigger OnInsert()
    begin
        if LinPack.Get("No. Packing", "No. Caja") then
            LinPack.TestField("Estado Caja", LinPack."Estado Caja"::Abierta);

        CCP.Reset;
        CCP.SetRange("No. Packing", "No. Packing");
        CCP.SetRange("No. Picking", "No. Picking");
        CCP.SetRange("No. Producto", "No. Producto");
        CCP.SetFilter("No. Linea", '<>%1', "No. Linea");
        if CCP.FindFirst then
            Error(Error002, CCP."No. Linea");
    end;

    trigger OnModify()
    begin
        if LinPack.Get("No. Packing", "No. Caja") then
            LinPack.TestField("Estado Caja", LinPack."Estado Caja"::Abierta);
    end;

    var
        Prod: Record Item;
        LinPack: Record "Lin. Packing";
        RWAL: Record "Registered Whse. Activity Line";
        ICR: Record "Item Reference";
        RWAL1: Record "Registered Whse. Activity Line";
        wCant: Decimal;
        Error001: Label 'Qty. can not exceed the Picking Quantity';
        wCant1: Decimal;
        CCP: Record "Contenido Cajas Packing";
        txt001: Label 'Barcode Not Found';
        CantPendEmp: Decimal;
        CantFaltante: Decimal;
        Error002: Label 'Este producto ya existe en la linea %1 de este Packing';
        txt002: Label 'Quantity %1 is greater than the remaining tiems to pack in the Posted Picking %2';
        Errorr003: Label 'El producto %1 no existe en el Picking %2';
}

