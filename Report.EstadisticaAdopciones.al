report 76101 "Estadistica Adopciones"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EstadisticaAdopciones.rdlc';

    dataset
    {
        dataitem("Temp Estadistica APS"; "Temp Estadistica APS")
        {
            DataItemTableView = SORTING("Sub Familia");
            RequestFilterFields = "Sub Familia";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(TextoEncabezado_1_; TextoEncabezado[1])
            {
            }
            column(TextoEncabezado_2_; TextoEncabezado[2])
            {
            }
            column(TextoEncabezado_3_; TextoEncabezado[3])
            {
            }
            column(TextoEncabezado_4_; TextoEncabezado[4])
            {
            }
            column(TextoEncabezado_5_; TextoEncabezado[5])
            {
            }
            column(TextoEncabezado_6_; TextoEncabezado[6])
            {
            }
            column(TextoEncabezado_7_; TextoEncabezado[7])
            {
            }
            column(TextoEncabezado_8_; TextoEncabezado[8])
            {
            }
            column(TextoEncabezado_9_; TextoEncabezado[9])
            {
            }
            column(TextoEncabezado_10_; TextoEncabezado[10])
            {
            }
            column(Temp_Estadistica_APS__Sub_Familia_; "Sub Familia")
            {
            }
            column(Valor_1_; Valor[1])
            {
            }
            column(Valor_2_; Valor[2])
            {
            }
            column(Valor_3_; Valor[3])
            {
            }
            column(Valor_4_; Valor[4])
            {
            }
            column(Valor_5_; Valor[5])
            {
            }
            column(Valor_6_; Valor[6])
            {
            }
            column(Valor_7_; Valor[7])
            {
            }
            column(Valor_8_; Valor[8])
            {
            }
            column(Valor_9_; Valor[9])
            {
            }
            column(Valor_10_; Valor[10])
            {
            }
            column(Valor_10__Control1000000028; Valor[10])
            {
            }
            column(Valor_9__Control1000000029; Valor[9])
            {
            }
            column(Valor_8__Control1000000030; Valor[8])
            {
            }
            column(Valor_17_; Valor[17])
            {
            }
            column(Valor_16_; Valor[16])
            {
            }
            column(Valor_15_; Valor[15])
            {
            }
            column(Valor_14_; Valor[14])
            {
            }
            column(Valor_13_; Valor[13])
            {
            }
            column(Valor_12_; Valor[12])
            {
            }
            column(Valor_11_; Valor[11])
            {
            }
            column(Adoption_StatisticCaption; Adoption_StatisticCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Temp_Estadistica_APS__Sub_Familia_Caption; FieldCaption("Sub Familia"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                for i := 1 to 60 do begin
                    if TextoEncabezado[i] = "Cod. Grado" then begin
                        i := 60;
                        Valor[i] := Format("Adopcion - 2INI");
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                DeleteAll;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ColAdopDetalle: Record "Colegio - Adopciones Detalle";
        Grados: Record "Datos auxiliares";
        TextoEncabezado: array[60] of Text[60];
        Valor: array[60] of Text[30];
        i: Integer;
        Adoption_StatisticCaptionLbl: Label 'Adoption Statistic';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';


    procedure RecibeDatos(CodCol: Code[20]; CodNivel: Code[20]; CodTurno: Code[20])
    begin
        i := 0;
        Grados.Reset;
        Grados.SetRange("Tipo registro", Grados."Tipo registro"::Grados);
        Grados.Find('-');
        repeat
            i += 1;
            TextoEncabezado[i] := Grados.Codigo;
        until Grados.Next = 0;

        ColAdopDetalle.Reset;
        ColAdopDetalle.SetRange("Cod. Colegio", CodCol);
        ColAdopDetalle.SetRange("Cod. Nivel", CodNivel);
        ColAdopDetalle.SetRange("Cod. Turno", CodTurno);
        //ColAdopDetalle.SETRANGE("Cod. Grado",CodGrado);
        ColAdopDetalle.FindSet;
        repeat
            "Temp Estadistica APS".Init;
            "Temp Estadistica APS"."Cod. Colegio" := ColAdopDetalle."Cod. Colegio";
            "Temp Estadistica APS"."Cod. Nivel" := ColAdopDetalle."Cod. Nivel";
            "Temp Estadistica APS"."Cod. Grado" := ColAdopDetalle."Cod. Grado";
            "Temp Estadistica APS"."Cod. Turno" := ColAdopDetalle."Cod. Turno";
            "Temp Estadistica APS"."Linea de negocio" := ColAdopDetalle."Linea de negocio";
            "Temp Estadistica APS".Familia := ColAdopDetalle.Familia;
            //fes mig "Temp Estadistica APS"."Sub Familia"      := ColAdopDetalle."Sub Familia";
            "Temp Estadistica APS".Serie := ColAdopDetalle.Serie;
            "Temp Estadistica APS"."Cod. Editorial" := ColAdopDetalle."Cod. Editorial";
            "Temp Estadistica APS"."Cod. Local" := ColAdopDetalle."Cod. Local";
            "Temp Estadistica APS"."Cod. Promotor" := ColAdopDetalle."Cod. Promotor";
            "Temp Estadistica APS"."Cod. Producto" := ColAdopDetalle."Cod. Producto";
            if "Temp Estadistica APS".FieldCaption("Cantidad - 2INI") = ColAdopDetalle."Cod. Grado" then begin
                "Temp Estadistica APS"."Cantidad - 2INI" := ColAdopDetalle."Cantidad Alumnos";
                "Temp Estadistica APS"."Adopcion - 2INI" := ColAdopDetalle.Adopcion;
            end
            else
                if "Temp Estadistica APS".FieldCaption("Cantidad - 3INI") = ColAdopDetalle."Cod. Grado" then begin
                    "Temp Estadistica APS"."Cantidad - 3INI" := ColAdopDetalle."Cantidad Alumnos";
                    "Temp Estadistica APS"."Adopcion - 3INI" := ColAdopDetalle.Adopcion;
                end
                else
                    if "Temp Estadistica APS".FieldCaption("Cantidad - 4INI") = ColAdopDetalle."Cod. Grado" then begin
                        "Temp Estadistica APS"."Cantidad - 4INI" := ColAdopDetalle."Cantidad Alumnos";
                        "Temp Estadistica APS"."Adopcion - 4INI" := ColAdopDetalle.Adopcion;
                    end
                    else
                        if "Temp Estadistica APS".FieldCaption("Cantidad - 5INI") = ColAdopDetalle."Cod. Grado" then begin
                            "Temp Estadistica APS"."Cantidad - 5INI" := ColAdopDetalle."Cantidad Alumnos";
                            "Temp Estadistica APS"."Adopcion - 5INI" := ColAdopDetalle.Adopcion;
                        end
                        else
                            if "Temp Estadistica APS".FieldCaption("Cantidad - 1PRI") = ColAdopDetalle."Cod. Grado" then begin
                                "Temp Estadistica APS"."Cantidad - 1PRI" := ColAdopDetalle."Cantidad Alumnos";
                                "Temp Estadistica APS"."Adopcion - 1PRI" := ColAdopDetalle.Adopcion;
                            end
                            else
                                if "Temp Estadistica APS".FieldCaption("Cantidad - 2PRI") = ColAdopDetalle."Cod. Grado" then begin
                                    "Temp Estadistica APS"."Cantidad - 2PRI" := ColAdopDetalle."Cantidad Alumnos";
                                    "Temp Estadistica APS"."Adopcion - 2PRI" := ColAdopDetalle.Adopcion;
                                end
                                else
                                    if "Temp Estadistica APS".FieldCaption("Cantidad - 3PRI") = ColAdopDetalle."Cod. Grado" then begin
                                        "Temp Estadistica APS"."Cantidad - 3PRI" := ColAdopDetalle."Cantidad Alumnos";
                                        "Temp Estadistica APS"."Adopcion - 3PRI" := ColAdopDetalle.Adopcion;
                                    end
                                    else
                                        if "Temp Estadistica APS".FieldCaption("Cantidad - 4PRI") = ColAdopDetalle."Cod. Grado" then begin
                                            "Temp Estadistica APS"."Cantidad - 4PRI" := ColAdopDetalle."Cantidad Alumnos";
                                            "Temp Estadistica APS"."Adopcion - 4PRI" := ColAdopDetalle.Adopcion;
                                        end
                                        else
                                            if "Temp Estadistica APS".FieldCaption("Cantidad - 5PRI") = ColAdopDetalle."Cod. Grado" then begin
                                                "Temp Estadistica APS"."Cantidad - 5PRI" := ColAdopDetalle."Cantidad Alumnos";
                                                "Temp Estadistica APS"."Adopcion - 5PRI" := ColAdopDetalle.Adopcion;
                                            end
                                            else
                                                if "Temp Estadistica APS".FieldCaption("Cantidad - 6PRI") = ColAdopDetalle."Cod. Grado" then begin
                                                    "Temp Estadistica APS"."Cantidad - 6PRI" := ColAdopDetalle."Cantidad Alumnos";
                                                    "Temp Estadistica APS"."Adopcion - 6PRI" := ColAdopDetalle.Adopcion;
                                                end
                                                else
                                                    if "Temp Estadistica APS".FieldCaption("Cantidad - 2INI") = ColAdopDetalle."Cod. Grado" then begin
                                                        "Temp Estadistica APS"."Cantidad - 2INI" := ColAdopDetalle."Cantidad Alumnos";
                                                        "Temp Estadistica APS"."Adopcion - 2INI" := ColAdopDetalle.Adopcion;
                                                    end
                                                    else
                                                        if "Temp Estadistica APS".FieldCaption("Cantidad - 1SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                            "Temp Estadistica APS"."Cantidad - 1SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                            "Temp Estadistica APS"."Adopcion - 1SEC" := ColAdopDetalle.Adopcion;
                                                        end
                                                        else
                                                            if "Temp Estadistica APS".FieldCaption("Cantidad - 2SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                "Temp Estadistica APS"."Cantidad - 2SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                                "Temp Estadistica APS"."Adopcion - 2SEC" := ColAdopDetalle.Adopcion;
                                                            end
                                                            else
                                                                if "Temp Estadistica APS".FieldCaption("Cantidad - 3SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                    "Temp Estadistica APS"."Cantidad - 3SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                                    "Temp Estadistica APS"."Adopcion - 3SEC" := ColAdopDetalle.Adopcion;
                                                                end
                                                                else
                                                                    if "Temp Estadistica APS".FieldCaption("Cantidad - 4SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                        "Temp Estadistica APS"."Cantidad - 4SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                                        "Temp Estadistica APS"."Adopcion - 4SEC" := ColAdopDetalle.Adopcion;
                                                                    end
                                                                    else
                                                                        if "Temp Estadistica APS".FieldCaption("Cantidad - 5SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                            "Temp Estadistica APS"."Cantidad - 5SEC" := ColAdopDetalle."Cantidad Alumnos";
                                                                            "Temp Estadistica APS"."Adopcion - 5SEC" := ColAdopDetalle.Adopcion;
                                                                        end
                                                                        else
                                                                            if "Temp Estadistica APS".FieldCaption("Cantidad - 1SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                "Temp Estadistica APS"."Cantidad - 1SEI" := ColAdopDetalle."Cantidad Alumnos";
                                                                                "Temp Estadistica APS"."Adopcion - 1SEI" := ColAdopDetalle.Adopcion;
                                                                            end
                                                                            else
                                                                                if "Temp Estadistica APS".FieldCaption("Cantidad - 2SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                    "Temp Estadistica APS"."Cantidad - 2SEI" := ColAdopDetalle."Cantidad Alumnos";
                                                                                    "Temp Estadistica APS"."Adopcion - 2SEI" := ColAdopDetalle.Adopcion;
                                                                                end
                                                                                else
                                                                                    if "Temp Estadistica APS".FieldCaption("Cantidad - 3SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                        "Temp Estadistica APS"."Cantidad - 3SEI" := ColAdopDetalle."Cantidad Alumnos";
                                                                                        "Temp Estadistica APS"."Adopcion - 3SEI" := ColAdopDetalle.Adopcion;
                                                                                    end
                                                                                    else
                                                                                        if "Temp Estadistica APS".FieldCaption("Cantidad - 4SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                            "Temp Estadistica APS"."Cantidad - 4SEI" := ColAdopDetalle."Cantidad Alumnos";
                                                                                            "Temp Estadistica APS"."Adopcion - 4SEI" := ColAdopDetalle.Adopcion;
                                                                                        end
                                                                                        else
                                                                                            if "Temp Estadistica APS".FieldCaption("Cantidad - 1VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                "Temp Estadistica APS"."Cantidad - 1VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                                "Temp Estadistica APS"."Adopcion - 1VA" := ColAdopDetalle.Adopcion;
                                                                                            end
                                                                                            else
                                                                                                if "Temp Estadistica APS".FieldCaption("Cantidad - 2VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                    "Temp Estadistica APS"."Cantidad - 2VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                                    "Temp Estadistica APS"."Adopcion - 2VA" := ColAdopDetalle.Adopcion;
                                                                                                end
                                                                                                else
                                                                                                    if "Temp Estadistica APS".FieldCaption("Cantidad - 3VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                        "Temp Estadistica APS"."Cantidad - 3VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                                        "Temp Estadistica APS"."Adopcion - 3VA" := ColAdopDetalle.Adopcion;
                                                                                                    end
                                                                                                    else
                                                                                                        if "Temp Estadistica APS".FieldCaption("Cantidad - 4VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                            "Temp Estadistica APS"."Cantidad - 4VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                                            "Temp Estadistica APS"."Adopcion - 4VA" := ColAdopDetalle.Adopcion;
                                                                                                        end
                                                                                                        else
                                                                                                            if "Temp Estadistica APS".FieldCaption("Cantidad - 5VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                                "Temp Estadistica APS"."Cantidad - 5VA" := ColAdopDetalle."Cantidad Alumnos";
                                                                                                                "Temp Estadistica APS"."Adopcion - 5VA" := ColAdopDetalle.Adopcion;
                                                                                                            end;

            "Temp Estadistica APS".Insert;
        until ColAdopDetalle.Next = 0;
    end;
}

