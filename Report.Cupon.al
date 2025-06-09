report 56043 Cupon
{
    DefaultLayout = RDLC;
    RDLCLayout = './Cupon.rdlc';

    dataset
    {
        dataitem("Cab. Cupon"; "Cab. Cupon.")
        {
            DataItemTableView = SORTING ("No. Cupon");
            RequestFilterFields = "No. Cupon";
            column(No__Cupon_____; '*' + "No. Cupon" + '*')
            {
            }
            column(UPPERCASE__ESTABLECIMIENTO______Cod__Colegio___________Nombre_Colegio_; UpperCase('ESTABLECIMIENTO: ') + "Cod. Colegio" + ' - ' + "Nombre Colegio")
            {
            }
            column(GradoAlum; GradoAlum)
            {
            }
            column(Cab__Cupon__Cab__Cupon___No__Cupon_; "Cab. Cupon"."No. Cupon")
            {
            }
            column(UPPERCASE_TXT001________Ano_Escolar__; UpperCase(TXT001 + ' ' + Campaña))
            {
            }
            column(PBX____rCompanyInf__Phone_No_____Ext_____419__302_y_370_________Fax____rCompanyInf__Fax_No__; 'PBX: ' + rCompanyInf."Phone No." + ' Ext.:' + '419, 302 y 370' + '-' + 'Fax: ' + rCompanyInf."Fax No.")
            {
            }
            column(PBX____rCompanyInf__Phone_No______Ext___419__302_y_370_________Fax____rCompanyInf__Fax_No__; 'PBX: ' + rCompanyInf."Phone No." + ' Ext.: 419, 302 y 370 ' + '-' + 'Fax: ' + rCompanyInf."Fax No.")
            {
            }
            column(Cab__Cupon__Cab__Cupon___No__Cupon__Control1000000012; "Cab. Cupon"."No. Cupon")
            {
            }
            column(Cab__Cupon__Cab__Cupon___Cod__Vendedor_; "Cab. Cupon"."Cod. Promotor")
            {
            }
            column(Cab__Cupon__Valido_Hasta_; "Valido Hasta")
            {
            }
            column(EmptyString; '-')
            {
            }
            column(EmptyString_Control1000000032; '-')
            {
            }
            column(CodLibro_1______txtDescripcion_1_; CodLibro[1] + ' ' + txtDescripcion[1])
            {
            }
            column(CodLibro_2______txtDescripcion_2_; CodLibro[2] + ' ' + txtDescripcion[2])
            {
            }
            column(CodLibro_3______txtDescripcion_3_; CodLibro[3] + ' ' + txtDescripcion[3])
            {
            }
            column(CodLibro_4______txtDescripcion_4_; CodLibro[4] + ' ' + txtDescripcion[4])
            {
            }
            column(CodLibro_5______txtDescripcion_5_; CodLibro[5] + ' ' + txtDescripcion[5])
            {
            }
            column(CodLibro_6______txtDescripcion_6_; CodLibro[6] + ' ' + txtDescripcion[6])
            {
            }
            column(UPPERCASE_TXT001________Ano_Escolar___Control1000000060; UpperCase(TXT001 + ' ' + Campaña))
            {
            }
            column(UPPERCASE__ESTABLECIMIENTO______Cod__Colegio___________Nombre_Colegio__Control1000000008; UpperCase('ESTABLECIMIENTO: ') + "Cod. Colegio" + ' - ' + "Nombre Colegio")
            {
            }
            column(EmptyString_Control1000000004; '-')
            {
            }
            column(GradoAlum_Control1000000014; GradoAlum)
            {
            }
            column(Grado_Caption; Grado_CaptionLbl)
            {
            }
            column(NO__CUPON_Caption; NO__CUPON_CaptionLbl)
            {
            }
            column(ASESOR_Caption; ASESOR_CaptionLbl)
            {
            }
            column(Vence_Caption; Vence_CaptionLbl)
            {
            }
            column(Firma_AutorizadaCaption; Firma_AutorizadaCaptionLbl)
            {
            }
            column(ZONA_1Caption; ZONA_1CaptionLbl)
            {
            }
            column(V6__Ave_y_10__Calle_Esquina_Local_2_1_3_Zona_1Caption; V6__Ave_y_10__Calle_Esquina_Local_2_1_3_Zona_1CaptionLbl)
            {
            }
            column(Edif_Plaza_Vivar__Tercer_Nivel___Tel__2220_0313__11_y_2232_6533Caption; Edif_Plaza_Vivar__Tercer_Nivel___Tel__2220_0313__11_y_2232_6533CaptionLbl)
            {
            }
            column(Local_28__Parque_de_la_Industria_Del_06_al_15_de_Enero_de_2012Caption; Local_28__Parque_de_la_Industria_Del_06_al_15_de_Enero_de_2012CaptionLbl)
            {
            }
            column(Parque_de_la_IndustriaCaption; Parque_de_la_IndustriaCaptionLbl)
            {
            }
            column("V6__Ave_0_60_Zona_4_Local_154B1__Guatemala___Teléfono_2338_0045Caption"; V6__Ave_0_60_Zona_4_Local_154B1__Guatemala___Teléfono_2338_0045CaptionLbl)
            {
            }
            column(Centro_Comercial_Zona_4Caption; Centro_Comercial_Zona_4CaptionLbl)
            {
            }
            column("V11_Ave_4_78_Apto_101_Zona_18_Atlántida___Tel__2255_2082__3019_4181Caption"; V11_Ave_4_78_Apto_101_Zona_18_Atlántida___Tel__2255_2082__3019_4181CaptionLbl)
            {
            }
            column(CC_Meta_Terminal_del_NorteCaption; CC_Meta_Terminal_del_NorteCaptionLbl)
            {
            }
            column(Calz_San_Juan_14_06_Zona_4_Local_71F__Mixco__Tel__2431_1675__3002_0008Caption; Calz_San_Juan_14_06_Zona_4_Local_71F__Mixco__Tel__2431_1675__3002_0008CaptionLbl)
            {
            }
            column(Centro_Comercial_MontserratCaption; Centro_Comercial_MontserratCaptionLbl)
            {
            }
            column(CC_Plaza_Villa_NuevaCaption; CC_Plaza_Villa_NuevaCaptionLbl)
            {
            }
            column(TitulosCaption; TitulosCaptionLbl)
            {
            }
            column("Calz__Concepción_5_26_Zona_6__Plaza_Villa_Nueva_L_13__Tel__6636_4172Caption"; Calz__Concepción_5_26_Zona_6__Plaza_Villa_Nueva_L_13__Tel__6636_4172CaptionLbl)
            {
            }
            column(Grado_Caption_Control1000000018; Grado_Caption_Control1000000018Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Impreso := true;
                Modify;

                I := 0;

                rLinCupon.Reset;
                rLinCupon.SetRange("No. Cupon", "Cab. Cupon"."No. Cupon");
                if rLinCupon.FindSet then
                    repeat
                        I += 1;
                        CodLibro[I] := rLinCupon."Cod. Producto";
                        txtDescripcion[I] := rLinCupon.Descripcion;
                        wDescuento[I] := rLinCupon."% Descuento";
                    until (rLinCupon.Next = 0) or (I = 6);

                //IF rGrado.GET("Grado del Alumno") THEN
                //  GradoAlum := rGrado.Descripcion
                //ELSE
                GradoAlum := ''
            end;

            trigger OnPreDataItem()
            begin
                rCompanyInf.Get;
                rCompanyInf.CalcFields(Picture);
                rConfSantillana.Get;
                rConfSantillana.TestField("Direccion Cupon tienda 1");
                rConfSantillana.TestField("Direccion Cupon tienda 2");
                rConfSantillana.TestField("Direccion Cupon tienda 3");
                rConfSantillana.TestField("Direccion Cupon tienda 4");
                rConfSantillana.TestField("Direccion Cupon tienda 5");
                rConfSantillana.TestField("Direccion Cupon tienda 6");

                Clear(CodLibro);
                Clear(txtDescripcion);
                Clear(txtDescripcion);
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
        rCompanyInf: Record "Company Information";
        TXT001: Label 'CUPON ESCOLAR';
        CodLibro: array[7] of Code[20];
        txtDescripcion: array[7] of Text[100];
        wDescuento: array[7] of Decimal;
        rLinCupon: Record "Lin. Cupon.";
        I: Integer;
        rConfSantillana: Record "Config. Empresa";
        GradoAlum: Text[100];
        rGrado: Record Grado;
        Grado_CaptionLbl: Label 'Grado:';
        NO__CUPON_CaptionLbl: Label 'NO. CUPON:';
        ASESOR_CaptionLbl: Label 'ASESOR:';
        Vence_CaptionLbl: Label 'Vence:';
        Firma_AutorizadaCaptionLbl: Label 'Firma Autorizada';
        ZONA_1CaptionLbl: Label 'ZONA 1';
        V6__Ave_y_10__Calle_Esquina_Local_2_1_3_Zona_1CaptionLbl: Label '6ª Ave y 10ª Calle Esquina Local 2/1-3 Zona 1';
        Edif_Plaza_Vivar__Tercer_Nivel___Tel__2220_0313__11_y_2232_6533CaptionLbl: Label 'Edif Plaza Vivar, Tercer Nivel,  Tel: 2220-0313, 11 y 2232-6533';
        Local_28__Parque_de_la_Industria_Del_06_al_15_de_Enero_de_2012CaptionLbl: Label 'Local 28, Parque de la Industria Del 06 al 15 de Enero de 2012';
        Parque_de_la_IndustriaCaptionLbl: Label 'Parque de la Industria';
        "V6__Ave_0_60_Zona_4_Local_154B1__Guatemala___Teléfono_2338_0045CaptionLbl": Label '6ª Ave 0-60 Zona 4 Local 154B1, Guatemala - Teléfono 2338-0045';
        Centro_Comercial_Zona_4CaptionLbl: Label 'Centro Comercial Zona 4';
        "V11_Ave_4_78_Apto_101_Zona_18_Atlántida___Tel__2255_2082__3019_4181CaptionLbl": Label '11 Ave 4-78 Apto 101 Zona 18 Atlántida,  Tel: 2255-2082, 3019-4181';
        CC_Meta_Terminal_del_NorteCaptionLbl: Label 'CC Meta Terminal del Norte';
        Calz_San_Juan_14_06_Zona_4_Local_71F__Mixco__Tel__2431_1675__3002_0008CaptionLbl: Label 'Calz San Juan 14-06 Zona 4 Local 71F, Mixco, Tel: 2431-1675, 3002-0008';
        Centro_Comercial_MontserratCaptionLbl: Label 'Centro Comercial Montserrat';
        CC_Plaza_Villa_NuevaCaptionLbl: Label 'CC Plaza Villa Nueva';
        TitulosCaptionLbl: Label 'Titulos';
        "Calz__Concepción_5_26_Zona_6__Plaza_Villa_Nueva_L_13__Tel__6636_4172CaptionLbl": Label 'Calz. Concepción 5-26 Zona 6, Plaza Villa Nueva L 13, Tel: 6636-4172';
        Grado_Caption_Control1000000018Lbl: Label 'Grado:';
}

