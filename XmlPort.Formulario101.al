xmlport 55001 "Formulario 101"
{

    schema
    {
        textelement(formulario)
        {
            textelement(cabecera)
            {
                textelement(codigo_version_formulario)
                {

                    trigger OnBeforePassVariable()
                    begin
                        codigo_version_formulario := '01201201';
                    end;
                }
                textelement(ruc)
                {
                }
                textelement(codigo_moneda)
                {
                }
            }
            textelement(detalle)
            {
                textelement(campo7)
                {
                }
                textelement(campo8)
                {
                }
                textelement(campo9)
                {
                }
                textelement(campo10)
                {
                }
                textelement(campo11)
                {
                }
                textelement(campo12)
                {
                }
                textelement(campo13)
                {
                }
                textelement(campo14)
                {
                }
                textelement(campo15)
                {
                }
                textelement(campo31)
                {
                }
                textelement(campo102)
                {
                }
                textelement(campo104)
                {
                }
                textelement(campo198)
                {
                }
                textelement(campo199)
                {
                }
                textelement(campo201)
                {
                }
                textelement(campo202)
                {
                }
                textelement(campo203)
                {
                }
                textelement(campo311)
                {
                }
                textelement(campo312)
                {
                }
                textelement(campo313)
                {
                }
                textelement(campo314)
                {
                }
                textelement(campo315)
                {
                }
                textelement(campo316)
                {
                }
                textelement(campo317)
                {
                }
                textelement(campo318)
                {
                }
                textelement(campo319)
                {
                }
                textelement(campo320)
                {
                }
                textelement(campo321)
                {
                }
                textelement(campo322)
                {
                }
                textelement(campo323)
                {
                }
                textelement(campo324)
                {
                }
                textelement(campo325)
                {
                }
                textelement(campo326)
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

