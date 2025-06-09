report 76226 "Colegios por promotor"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Colegiosporpromotor.rdlc';

    dataset
    {
        dataitem(Adopciones; "Colegio - Adopciones Cab")
        {
            DataItemTableView = SORTING("Cod. Promotor", "Cod. Colegio");
            RequestFilterFields = "Cod. Promotor", "Cod. Colegio";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(codGrados_1_; codGrados[1])
            {
            }
            column(codGrados_2_; codGrados[2])
            {
            }
            column(codGrados_4_; codGrados[4])
            {
            }
            column(codGrados_3_; codGrados[3])
            {
            }
            column(codGrados_6_; codGrados[6])
            {
            }
            column(codGrados_5_; codGrados[5])
            {
            }
            column(codGrados_9_; codGrados[9])
            {
            }
            column(codGrados_8_; codGrados[8])
            {
            }
            column(codGrados_7_; codGrados[7])
            {
            }
            column(codGrados_10_; codGrados[10])
            {
            }
            column(codGrados_11_; codGrados[11])
            {
            }
            column(codGrados_12_; codGrados[12])
            {
            }
            column(codGrados_18_; codGrados[18])
            {
            }
            column(codGrados_17_; codGrados[17])
            {
            }
            column(codGrados_16_; codGrados[16])
            {
            }
            column(codGrados_15_; codGrados[15])
            {
            }
            column(codGrados_14_; codGrados[14])
            {
            }
            column(codGrados_13_; codGrados[13])
            {
            }
            column(codGrados_19_; codGrados[19])
            {
            }
            column(Adopciones__Cod__Promotor_; "Cod. Promotor")
            {
            }
            column(Adopciones__Nombre_Promotor_; "Nombre Promotor")
            {
            }
            column(texDistrito; texDistrito)
            {
            }
            column(decTotalGrado_1_; decTotalGrado[1])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_2_; decTotalGrado[2])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_3_; decTotalGrado[3])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_4_; decTotalGrado[4])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_5_; decTotalGrado[5])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_6_; decTotalGrado[6])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_7_; decTotalGrado[7])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_8_; decTotalGrado[8])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_9_; decTotalGrado[9])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_10_; decTotalGrado[10])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_11_; decTotalGrado[11])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_12_; decTotalGrado[12])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_18_; decTotalGrado[18])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_17_; decTotalGrado[17])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_16_; decTotalGrado[16])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_15_; decTotalGrado[15])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_14_; decTotalGrado[14])
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalGrado_13_; decTotalGrado[13])
            {
                DecimalPlaces = 0 : 2;
            }
            column(codCategoria; codCategoria)
            {
            }
            column(decTotalGrado_19_; decTotalGrado[19])
            {
                DecimalPlaces = 0 : 2;
            }
            column(Adopciones__Cod__Colegio_; "Cod. Colegio")
            {
            }
            column(Adopciones__Nombre_Colegio_; "Nombre Colegio")
            {
            }
            column(Colegios_por_promotorCaption; Colegios_por_promotorCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(codCategoriaCaption; codCategoriaCaptionLbl)
            {
            }
            column(texDistritoCaption; texDistritoCaptionLbl)
            {
            }
            column(Adopciones__Cod__Colegio_Caption; Adopciones__Cod__Colegio_CaptionLbl)
            {
            }
            column(Adopciones__Nombre_Colegio_Caption; FieldCaption("Nombre Colegio"))
            {
            }
            column(Adopciones__Cod__Promotor_Caption; Adopciones__Cod__Promotor_CaptionLbl)
            {
            }
            column(Adopciones_Turno; Turno)
            {
            }

            trigger OnAfterGetRecord()
            begin

                Clear(texDistrito);

                codCategoria := TraerCategoria("Cod. Colegio", "Cod. Nivel");
                if recColegio.Get("Cod. Colegio") then
                    texDistrito := recColegio.Distritos;

                CargarTotalGrados;
            end;

            trigger OnPreDataItem()
            begin
                CargarGrados;
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
        recColegio: Record Contact;
        codCategoria: Code[10];
        texDistrito: Text[30];
        codGrados: array[20] of Code[20];
        decTotalGrado: array[20] of Decimal;
        Colegios_por_promotorCaptionLbl: Label 'Colegios por promotor';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        codCategoriaCaptionLbl: Label 'Cat.';
        texDistritoCaptionLbl: Label 'Distrito';
        Adopciones__Cod__Colegio_CaptionLbl: Label 'Cód. Colegio';
        Adopciones__Cod__Promotor_CaptionLbl: Label 'Promotor:';


    procedure TraerCategoria(codPrmColegio: Code[20]; codPrmNivel: Code[20]): Code[10]
    var
        recNivel: Record "Colegio - Nivel";
    begin
        recNivel.Reset;
        recNivel.SetRange("Cod. Colegio", codPrmColegio);
        //recNivel.SETRANGE("Cod. Promotor", codPrmProm);
        recNivel.SetRange("Cod. Nivel", codPrmNivel);
        if recNivel.FindFirst then
            exit(recNivel."Categoria colegio");
    end;


    procedure CargarGrados()
    var
        recGrados: Record "Datos auxiliares";
        i: Integer;
    begin
        recGrados.Reset;
        recGrados.SetCurrentKey("Orden en informes");
        recGrados.SetFilter("Orden en informes", '<>%1', 0);
        recGrados.SetRange("Tipo registro", recGrados."Tipo registro"::Grados);

        if recGrados.FindSet then
            repeat
                i += 1;
                codGrados[i] := recGrados.Codigo;
            until (recGrados.Next = 0) or (i = ArrayLen(codGrados));
    end;


    procedure CargarTotalGrados()
    var
        recDetalle: Record "Colegio - Adopciones Detalle";
        i: Integer;
    begin
        for i := 1 to ArrayLen(codGrados) do begin
            recDetalle.Reset;
            recDetalle.SetCurrentKey("Cod. Colegio", "Cod. Grado", "Cod. Promotor", Adopcion);
            recDetalle.SetRange("Cod. Colegio", Adopciones."Cod. Colegio");
            recDetalle.SetRange("Cod. Promotor", Adopciones."Cod. Promotor");
            recDetalle.SetRange("Cod. Grado", codGrados[i]);
            recDetalle.SetFilter(Adopcion, '%1|%2', recDetalle.Adopcion::Conquista, recDetalle.Adopcion::Mantener);
            recDetalle.CalcSums("Adopcion Real");
            decTotalGrado[i] := recDetalle."Adopcion Real";
        end;
    end;
}

