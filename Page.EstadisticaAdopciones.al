#pragma implicitwith disable
page 76204 "Estadistica Adopciones"
{
    ApplicationArea = all;
    Editable = false;
    PageType = Card;
    SourceTable = "Temp Estadistica APS";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Sub Familia"; rec."Sub Familia")
                {
                    Caption = 'Value';
                }
                field("Adopcion - 2INI"; rec."Adopcion - 2INI")
                {
                }
                field("Adopcion - 3INI"; rec."Adopcion - 3INI")
                {
                }
                field("Adopcion - 4INI"; rec."Adopcion - 4INI")
                {
                }
                field("Adopcion - 5INI"; rec."Adopcion - 5INI")
                {
                }
                field("Adopcion - 1PRI"; rec."Adopcion - 1PRI")
                {
                }
                field("Adopcion - 2PRI"; rec."Adopcion - 2PRI")
                {
                }
                field("Adopcion - 3PRI"; rec."Adopcion - 3PRI")
                {
                }
                field("Adopcion - 4PRI"; rec."Adopcion - 4PRI")
                {
                }
                field("Adopcion - 5PRI"; rec."Adopcion - 5PRI")
                {
                }
                field("Adopcion - 6PRI"; rec."Adopcion - 6PRI")
                {
                }
                field("Adopcion - 1SEC"; rec."Adopcion - 1SEC")
                {
                }
                field("Adopcion - 2SEC"; rec."Adopcion - 2SEC")
                {
                }
                field("Adopcion - 3SEC"; rec."Adopcion - 3SEC")
                {
                }
                field("Adopcion - 4SEC"; rec."Adopcion - 4SEC")
                {
                }
                field("Adopcion - 5SEC"; rec."Adopcion - 5SEC")
                {
                }
                field("Adopcion - 1SEI"; rec."Adopcion - 1SEI")
                {
                }
                field("Adopcion - 2SEI"; rec."Adopcion - 2SEI")
                {
                }
                field("Adopcion - 3SEI"; rec."Adopcion - 3SEI")
                {
                }
                field("Adopcion - 4SEI"; rec."Adopcion - 4SEI")
                {
                }
                field("Adopcion - 1VA"; rec."Adopcion - 1VA")
                {
                }
                field("Adopcion - 2VA"; rec."Adopcion - 2VA")
                {
                }
                field("Adopcion - 3VA"; rec."Adopcion - 3VA")
                {
                }
                field("Adopcion - 4VA"; rec."Adopcion - 4VA")
                {
                }
                field("Adopcion - 5VA"; rec."Adopcion - 5VA")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        ConfAPS: Record "Commercial Setup";
        TextoEncabezado: array[30] of Text[30];
        DimValue: Text[60];
        i: Integer;


    procedure RecibeParametros(CodCol: Code[20])
    var
        ColAdopDetalle: Record "Colegio - Adopciones Detalle";
        Grados: Record "Datos auxiliares";
    begin
        ConfAPS.Get();
        ConfAPS.TestField("Dim para Estad. Adopciones");
        i := 0;
        DimValue := 'aaa';
        Grados.Reset;
        Grados.SetRange("Tipo registro", Grados."Tipo registro"::Grados);
        Grados.Find('-');
        repeat
            i += 1;
            TextoEncabezado[i] := Grados.Codigo;
        until Grados.Next = 0;

        ColAdopDetalle.Reset;
        ColAdopDetalle.SetCurrentKey("Cod. Colegio", "Linea de negocio", Familia, "Sub Familia", Serie, "Grupo de Negocio");
        ColAdopDetalle.SetRange("Cod. Colegio", CodCol);
        //ColAdopDetalle.SETRANGE("Cod. Nivel",CodNivel);
        //ColAdopDetalle.SETRANGE("Cod. Turno",CodTurno);
        //ColAdopDetalle.SETRANGE("Cod. Grado",CodGrado);
        ColAdopDetalle.FindSet;
        repeat
            if ConfAPS."Dim para Estad. Adopciones" = ConfAPS."Cod. Dimension Lin. Negocio" then begin
                if ColAdopDetalle."Linea de negocio" <> DimValue then begin
                    Rec.Init;
                    DimValue := ColAdopDetalle."Linea de negocio";
                end;
            end
            else
                if ConfAPS."Dim para Estad. Adopciones" = ConfAPS."Cod. Dimension Familia" then begin
                    if ColAdopDetalle.Familia <> DimValue then begin
                        Rec.Init;
                        DimValue := ColAdopDetalle.Familia;
                    end;
                end
                else
                    //fes mig
                    /*
                    IF ConfAPS."Dim para Estad. Adopciones" = ConfAPS."Cod. Dimension Sub Familia" THEN
                       BEGIN
                        IF ColAdopDetalle."Sub Familia" <> DimValue THEN
                           BEGIN
                            INIT;
                            DimValue := ColAdopDetalle."Sub Familia";
                           END;
                       END
                    ELSE
                    */
                    //fes mig
                    if ConfAPS."Dim para Estad. Adopciones" = ConfAPS."Cod. Dimension Serie" then begin
                        if ColAdopDetalle.Serie <> DimValue then begin
                            Rec.Init;
                            DimValue := ColAdopDetalle.Serie;
                        end;
                    end;

            Rec."Cod. Colegio" := ColAdopDetalle."Cod. Colegio";
            Rec."Cod. Nivel" := ColAdopDetalle."Cod. Nivel";
            Rec."Cod. Grado" := ColAdopDetalle."Cod. Grado";
            Rec."Cod. Turno" := ColAdopDetalle."Cod. Turno";
            Rec."Linea de negocio" := ColAdopDetalle."Linea de negocio";
            Rec.Familia := ColAdopDetalle.Familia;
            Rec."Sub Familia" := DimValue;
            Rec.Serie := ColAdopDetalle.Serie;
            Rec."Cod. Editorial" := ColAdopDetalle."Cod. Editorial";
            Rec."Cod. Local" := ColAdopDetalle."Cod. Local";
            Rec."Cod. Promotor" := ColAdopDetalle."Cod. Promotor";
            Rec."Cod. Producto" := ColAdopDetalle."Cod. Producto";
            if Rec.FieldCaption("Cantidad - 2INI") = ColAdopDetalle."Cod. Grado" then begin
                Rec."Cantidad - 2INI" := ColAdopDetalle."Cantidad Alumnos";
                Rec."Adopcion - 2INI" := ColAdopDetalle.Adopcion;
            end
            else
                if Rec.FieldCaption("Cantidad - 3INI") = ColAdopDetalle."Cod. Grado" then begin
                    Rec."Cantidad - 3INI" := ColAdopDetalle."Cantidad Alumnos";
                    Rec."Adopcion - 3INI" := ColAdopDetalle.Adopcion;
                end
                else
                    if Rec.FieldCaption("Cantidad - 4INI") = ColAdopDetalle."Cod. Grado" then begin
                        Rec."Cantidad - 4INI" := ColAdopDetalle."Cantidad Alumnos";
                        Rec."Adopcion - 4INI" := ColAdopDetalle.Adopcion;
                    end
                    else
                        if Rec.FieldCaption("Cantidad - 5INI") = ColAdopDetalle."Cod. Grado" then begin
                            Rec."Cantidad - 5INI" := ColAdopDetalle."Cantidad Alumnos";
                            Rec."Adopcion - 5INI" := ColAdopDetalle.Adopcion;
                        end
                        else
                            if Rec.FieldCaption("Cantidad - 1PRI") = ColAdopDetalle."Cod. Grado" then begin
                                Rec."Cantidad - 1PRI" := ColAdopDetalle."Cantidad Alumnos";
                                Rec."Adopcion - 1PRI" := ColAdopDetalle.Adopcion;
                            end
                            else
                                if Rec.FieldCaption("Cantidad - 2PRI") = ColAdopDetalle."Cod. Grado" then begin
                                    Rec."Cantidad - 2PRI" := ColAdopDetalle."Cantidad Alumnos";
                                    Rec."Adopcion - 2PRI" := ColAdopDetalle.Adopcion;
                                end
                                else
                                    if Rec.FieldCaption("Cantidad - 3PRI") = ColAdopDetalle."Cod. Grado" then begin
                                        Rec."Cantidad - 3PRI" := ColAdopDetalle."Cantidad Alumnos";
                                        Rec."Adopcion - 3PRI" := ColAdopDetalle.Adopcion;
                                    end
                                    else
                                        if Rec.FieldCaption("Cantidad - 4PRI") = ColAdopDetalle."Cod. Grado" then begin
                                            Rec."Cantidad - 4PRI" := ColAdopDetalle."Cantidad Alumnos";
                                            Rec."Adopcion - 4PRI" := ColAdopDetalle.Adopcion;
                                        end
                                        else
                                            if Rec.FieldCaption("Cantidad - 5PRI") = ColAdopDetalle."Cod. Grado" then begin
                                                Rec."Cantidad - 5PRI" := ColAdopDetalle."Cantidad Alumnos";
                                                Rec."Adopcion - 5PRI" := ColAdopDetalle.Adopcion;
                                            end
                                            else
                                                if Rec.FieldCaption("Cantidad - 6PRI") = ColAdopDetalle."Cod. Grado" then begin
                                                    Rec."Cantidad - 6PRI" := ColAdopDetalle."Cantidad Alumnos";
                                                    Rec."Adopcion - 6PRI" := ColAdopDetalle.Adopcion;
                                                end
                                                else
                                                    if Rec.FieldCaption("Cantidad - 1SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                        Rec."Cantidad - 1SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                        Rec."Adopcion - 1SEC" := ColAdopDetalle.Adopcion;
                                                    end
                                                    else
                                                        if Rec.FieldCaption("Cantidad - 2SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                            Rec."Cantidad - 2SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                            Rec."Adopcion - 2SEC" := ColAdopDetalle.Adopcion;
                                                        end
                                                        else
                                                            if Rec.FieldCaption("Cantidad - 3SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                Rec."Cantidad - 3SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                                Rec."Adopcion - 3SEC" := ColAdopDetalle.Adopcion;
                                                            end
                                                            else
                                                                if Rec.FieldCaption("Cantidad - 4SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                    Rec."Cantidad - 4SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                                    Rec."Adopcion - 4SEC" := ColAdopDetalle.Adopcion;
                                                                end
                                                                else
                                                                    if Rec.FieldCaption("Cantidad - 5SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                        Rec."Cantidad - 5SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                                        Rec."Adopcion - 5SEC" := ColAdopDetalle.Adopcion;
                                                                    end
                                                                    else
                                                                        if Rec.FieldCaption("Cantidad - 1SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                            Rec."Cantidad - 1SEI" := ColAdopDetalle."Cantidad Alumnos";
                                                                            Rec."Adopcion - 1SEI" := ColAdopDetalle.Adopcion;
                                                                        end
                                                                        else
                                                                            if Rec.FieldCaption("Cantidad - 2SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                Rec."Cantidad - 2SEI" := ColAdopDetalle."Cantidad Alumnos";
                                                                                Rec."Adopcion - 2SEI" := ColAdopDetalle.Adopcion;
                                                                            end
                                                                            else
                                                                                if Rec.FieldCaption("Cantidad - 3SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                    Rec."Cantidad - 3SEI" := ColAdopDetalle."Cantidad Alumnos";
                                                                                    Rec."Adopcion - 3SEI" := ColAdopDetalle.Adopcion;
                                                                                end
                                                                                else
                                                                                    if Rec.FieldCaption("Cantidad - 4SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                        Rec."Cantidad - 4SEI" := ColAdopDetalle."Cantidad Alumnos";
                                                                                        Rec."Adopcion - 4SEI" := ColAdopDetalle.Adopcion;
                                                                                    end
                                                                                    else
                                                                                        if Rec.FieldCaption("Cantidad - 1VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                            Rec."Cantidad - 1VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                            Rec."Adopcion - 1VA" := ColAdopDetalle.Adopcion;
                                                                                        end
                                                                                        else
                                                                                            if Rec.FieldCaption("Cantidad - 2VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                Rec."Cantidad - 2VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                                Rec."Adopcion - 2VA" := ColAdopDetalle.Adopcion;
                                                                                            end
                                                                                            else
                                                                                                if Rec.FieldCaption("Cantidad - 3VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                    Rec."Cantidad - 3VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                                    Rec."Adopcion - 3VA" := ColAdopDetalle.Adopcion;
                                                                                                end
                                                                                                else
                                                                                                    if Rec.FieldCaption("Cantidad - 4VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                        Rec."Cantidad - 4VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                                        Rec."Adopcion - 4VA" := ColAdopDetalle.Adopcion;
                                                                                                    end
                                                                                                    else
                                                                                                        if Rec.FieldCaption("Cantidad - 5VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                            Rec."Cantidad - 5VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                                            Rec."Adopcion - 5VA" := ColAdopDetalle.Adopcion;
                                                                                                        end;

            if not Rec.Insert then
                Rec.Modify;
        until ColAdopDetalle.Next = 0;

    end;
}

#pragma implicitwith restore

