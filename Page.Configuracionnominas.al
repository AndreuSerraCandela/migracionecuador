#pragma implicitwith disable
page 76154 "Configuracion nominas"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Configuracion nominas";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Método cálculo ausencias"; rec."Método cálculo ausencias")
                {
                    Importance = Additional;
                }
                field("Metodo calculo Ingresos"; rec."Metodo calculo Ingresos")
                {
                    Importance = Additional;
                }
                field("Metodo calculo Salidas"; rec."Metodo calculo Salidas")
                {
                    Importance = Additional;
                }
                field("Dimension Conceptos Salariales"; rec."Dimension Conceptos Salariales")
                {
                }
                field("Tasa Cambio Calculo Divisa"; rec."Tasa Cambio Calculo Divisa")
                {
                }
                field("Path Archivos Electronicos"; rec."Path Archivos Electronicos")
                {
                }
                field("Texto email recibos"; rec."Texto email recibos")
                {
                }
                field("Tiempo espera Envio email"; rec."Tiempo espera Envio email")
                {
                }
                field("Salario Minimo"; rec."Salario Minimo")
                {
                }
                field("Impuestos manuales"; rec."Impuestos manuales")
                {
                    Importance = Additional;
                }
                field("Metodo Calculo SS"; rec."Metodo Calculo SS")
                {
                }
                field("Nomina de Pais"; rec."Nomina de Pais")
                {
                    Importance = Additional;
                }
                field("ID Informe de nomina"; rec."ID Informe de nomina")
                {
                    Importance = Additional;
                }
                field("Codeunit calculo nomina"; rec."Codeunit calculo nomina")
                {
                    Importance = Additional;
                }
                field("Codeunit Archivos Electronicos"; rec."Codeunit Archivos Electronicos")
                {
                    Importance = Additional;
                }
                field("XML importa datos ponchador"; rec."XML importa datos ponchador")
                {
                    Importance = Additional;
                }
                field("Usar Acciones de personal"; rec."Usar Acciones de personal")
                {
                    Importance = Additional;
                }
                field("Calcular horas reg. asistencia"; rec."Calcular horas reg. asistencia")
                {
                    Importance = Additional;
                }
                field("Dias para corte nominas"; rec."Dias para corte nominas")
                {
                    Importance = Additional;
                }
                field("Multiempresa activo"; rec."Multiempresa activo")
                {
                    Importance = Additional;
                }
                field("Habilitar numeradores globales"; rec."Habilitar numeradores globales")
                {
                    Importance = Additional;
                }
                field("Mod. cooperativa activo"; rec."Mod. cooperativa activo")
                {
                    Importance = Additional;
                }
                field("Adelantar salario vacaciones"; rec."Adelantar salario vacaciones")
                {
                    Importance = Additional;
                }
                field("Tiempo minimo prest. coop."; rec."Tiempo minimo prest. coop.")
                {
                    Importance = Additional;
                }
                field("Integracion ponche activa"; rec."Integracion ponche activa")
                {
                    Importance = Additional;
                }
                field("CU Procesa datos ponchador"; rec."CU Procesa datos ponchador")
                {
                    Importance = Additional;
                }
                field("Completar horas ponchador"; rec."Completar horas ponchador")
                {
                    Importance = Additional;
                }
                field("Horas de almuerzo"; rec."Horas de almuerzo")
                {
                    Importance = Additional;
                }
                field("Prioridad correos"; rec."Prioridad correos")
                {
                    Importance = Additional;
                }
                field("Act. Excluido TSS automatico"; rec."Act. Excluido TSS automatico")
                {
                    Importance = Additional;
                }
            }
            group("Salary Wages")
            {
                Caption = 'Salary Wages';
                field("Concepto Sal. Base"; rec."Concepto Sal. Base")
                {
                }
                field("Concepto Sal. hora"; rec."Concepto Sal. hora")
                {
                }
                field("Concepto ISR"; rec."Concepto ISR")
                {
                }
                field("Concepto devolucion ISR"; rec."Concepto devolucion ISR")
                {
                }
                field("Concepto Retroactivo"; rec."Concepto Retroactivo")
                {
                }
                field("Concepto AFP"; rec."Concepto AFP")
                {
                }
                field("Concepto SFS"; rec."Concepto SFS")
                {
                }
                field("Concepto SRL"; rec."Concepto SRL")
                {
                }
                field("Concepto INFOTEP"; rec."Concepto INFOTEP")
                {
                }
                field("Concepto CxC Empl."; rec."Concepto CxC Empl.")
                {
                }
                field("Concepto Cuota cooperativa"; rec."Concepto Cuota cooperativa")
                {
                }
                field("Concepto Vacaciones"; rec."Concepto Vacaciones")
                {
                }
                field("Concepto Inasistencia"; rec."Concepto Inasistencia")
                {
                    Importance = Additional;
                }
                field("Concepto Regalia"; rec."Concepto Regalia")
                {
                }
                field("Concepto Bonificacion"; rec."Concepto Bonificacion")
                {
                }
                field("Concepto Preaviso"; rec."Concepto Preaviso")
                {
                }
                field("Concepto Cesantia"; rec."Concepto Cesantia")
                {
                }
                field("Concepto Horas Ext. 35%"; rec."Concepto Horas Ext. 35%")
                {
                }
                field("Concepto Horas Ext. 100%"; rec."Concepto Horas Ext. 100%")
                {
                }
                field("Concepto Dias feriados"; rec."Concepto Dias feriados")
                {
                }
                field("Concepto Horas nocturnas"; rec."Concepto Horas nocturnas")
                {
                }
                field("Concepto Incentivos"; rec."Concepto Incentivos")
                {
                }
                field("Concepto Reembolso gtos."; rec."Concepto Reembolso gtos.")
                {
                    Importance = Additional;
                }
                field("Concepto Decimo Tercero"; rec."Concepto Decimo Tercero")
                {
                }
                field("Concepto Decimo Cuarto"; rec."Concepto Decimo Cuarto")
                {
                }
            }
            group(Government)
            {
                Caption = 'Government';
                field("Web Page TSS"; rec."Web Page TSS")
                {
                }
                field("Web Page DGII"; rec."Web Page DGII")
                {
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Journal Template Name"; rec."Journal Template Name")
                {
                }
                field("Journal Batch Name"; rec."Journal Batch Name")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Secc: Record "Gen. Journal Batch";
                    begin
                        Secc.Reset;
                        Secc.SetRange("Journal Template Name", Rec."Journal Template Name");
                        if PAGE.RunModal(PAGE::"General Journal Batches", Secc) = ACTION::LookupOK then
                            Rec."Journal Batch Name" := Secc.Name
                        else
                            Rec."Journal Batch Name" := '';
                    end;
                }
                field("Tipo cuenta"; rec."Tipo cuenta")
                {
                }
                field("Cód. Cta. Nominas Pago Transf."; rec."Cód. Cta. Nominas Pago Transf.")
                {
                }
                field("Tipo Cta. Otros Pagos"; rec."Tipo Cta. Otros Pagos")
                {
                }
                field("Cta. Nominas Otros Pagos"; rec."Cta. Nominas Otros Pagos")
                {
                }
                field("Journal Template Name CK"; rec."Journal Template Name CK")
                {
                }
                field("Journal Batch Name CK"; rec."Journal Batch Name CK")
                {
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("No. serie nominas"; rec."No. serie nominas")
                {
                }
                field("No. serie CxC"; rec."No. serie CxC")
                {
                }
                field("No. serie reg. CxC"; rec."No. serie reg. CxC")
                {
                }
                field("No. serie Sol. Prest. Coop."; rec."No. serie Sol. Prest. Coop.")
                {
                }
                field("No. serie Hist. Prest. Coop."; rec."No. serie Hist. Prest. Coop.")
                {
                }
            }
            group(Job)
            {
                Caption = 'Job';
                field("Job Journal Template Name"; rec."Job Journal Template Name")
                {
                }
                field("Job Journal Batch Name"; rec."Job Journal Batch Name")
                {
                }
            }
            group(Captions)
            {
                Caption = 'Captions';
                field("Caption Depto"; rec."Caption Depto")
                {
                }
                field("Caption Sub Depto"; rec."Caption Sub Depto")
                {
                }
                field("Caption ISR"; rec."Caption ISR")
                {
                }
                field("Caption INFOTEP"; rec."Caption INFOTEP")
                {
                }
                field("Caption AFP"; rec."Caption AFP")
                {
                }
                field("Caption SFS"; rec."Caption SFS")
                {
                }
                field("Caption SRL"; rec."Caption SRL")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Calendar")
            {
                Caption = '&Calendar';
                action("Vacation parameters")
                {
                    Caption = 'Vacation parameters';
                    Image = NumberSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Parametros vacaciones";
                }
            }
        }
    }
}

#pragma implicitwith restore

