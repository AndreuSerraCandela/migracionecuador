xmlport 76049 "Conceptos salariales"
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(ConceptosSalariales)
        {
            tableelement("Conceptos salariales"; "Conceptos salariales")
            {
                XmlName = 'ConceptosSalariales';
                fieldelement(CS_ShortcutDimension; "Conceptos salariales"."Dimension Nomina")
                {
                }
                fieldelement(CS_Codigo; "Conceptos salariales".Codigo)
                {
                }
                fieldelement(CS_Descripcion; "Conceptos salariales".Descripcion)
                {
                }
                fieldelement(CS_TipoConcepto; "Conceptos salariales"."Tipo concepto")
                {
                }
                fieldelement(CS_SalarioBase; "Conceptos salariales"."Salario Base")
                {
                }
                fieldelement(CS_SujetoCotizacion; "Conceptos salariales"."Sujeto Cotizacion")
                {
                }
                fieldelement(CS_TextoInformativo; "Conceptos salariales"."Texto Informativo")
                {
                }
                fieldelement(CS_FilaImpresionNomina; "Conceptos salariales"."Fila Impresion Nomina")
                {
                }
                fieldelement(CS_ColImpresionNomina; "Conceptos salariales"."Col. Impresion Nomina")
                {
                }
                fieldelement(CS_ImprimirDescripcion; "Conceptos salariales"."Imprimir descripcion")
                {
                }
                fieldelement(CS_Provisionar; "Conceptos salariales".Provisionar)
                {
                }
                fieldelement(CS_NoCuentaCuotaObrera; "Conceptos salariales"."No. Cuenta Cuota Obrera")
                {
                }
                fieldelement(CS_ContabilizacionResumida; "Conceptos salariales"."Contabilizacion Resumida")
                {
                }
                fieldelement(CS_ContabilizacionDimension; "Conceptos salariales"."Contabilizacion x Dimension")
                {
                }
                fieldelement(CS_SumarRestarCuentaSalarios; "Conceptos salariales"."Sumar/Restar a cuenta salarios")
                {
                }
                fieldelement(CS_CotizaAFP; "Conceptos salariales"."Cotiza AFP")
                {
                }
                fieldelement(CS_CotizaSRL; "Conceptos salariales"."Cotiza SRL")
                {
                }
                fieldelement(CS_CotizaINFOTEP; "Conceptos salariales"."Cotiza INFOTEP")
                {
                }
                fieldelement(CS_CotizaISR; "Conceptos salariales"."Cotiza ISR")
                {
                }
                fieldelement(CS_CotizaSFS; "Conceptos salariales"."Cotiza SFS")
                {
                }
                fieldelement(CS_TipoCuentaCuotaObrera; "Conceptos salariales"."Tipo Cuenta Cuota Obrera")
                {
                }
                fieldelement(CS_TipoCuentaCuotaPatronal; "Conceptos salariales"."Tipo Cuenta Cuota Patronal")
                {
                }
                fieldelement(CS_NoCuentaCuotaPatronal; "Conceptos salariales"."No. Cuenta Cuota Patronal")
                {
                }
                fieldelement(CS_TipoCuentaContrapartidaCO; "Conceptos salariales"."Tipo Cuenta Contrapartida CO")
                {
                }
                fieldelement(CS_NoCuentaContrapartidaCO; "Conceptos salariales"."No. Cuenta Contrapartida CO")
                {
                }
                fieldelement(CS_TipoCuentaContrapartidaCP; "Conceptos salariales"."Tipo Cuenta Contrapartida CP")
                {
                }
                fieldelement(CS_NoCuentaContrapartidaCP; "Conceptos salariales"."No. Cuenta Contrapartida CP")
                {
                }
                fieldelement(CS_ValidarContrapartidaCO; "Conceptos salariales"."Validar Contrapartida CO")
                {
                }
                fieldelement(CS_ValidarContrapartidaCP; "Conceptos salariales"."Validar Contrapartida CP")
                {
                }
                fieldelement(CS_AplicaRegalia; "Conceptos salariales"."Aplica para Regalia")
                {
                }
                fieldelement(CS_CotizaSUTA; "Conceptos salariales"."Cotiza SUTA")
                {
                }
                fieldelement(CS_CotizaFUTA; "Conceptos salariales"."Cotiza FUTA")
                {
                }
                fieldelement(CS_CotizaMEDICARE; "Conceptos salariales"."Cotiza MEDICARE")
                {
                }
                fieldelement(CS_CotizaFICA; "Conceptos salariales"."Cotiza FICA")
                {
                }
                fieldelement(CS_CotizaSINOT; "Conceptos salariales"."Cotiza SINOT")
                {
                }
                fieldelement(CS_CotizaCHOFERIL; "Conceptos salariales"."Cotiza CHOFERIL")
                {
                }
                fieldelement(CS_CotizaINCOMETAX; "Conceptos salariales"."Cotiza INCOMETAX")
                {
                }
            }
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
}

