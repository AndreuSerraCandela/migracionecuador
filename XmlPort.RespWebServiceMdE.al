xmlport 56201 "Resp. Web Service MdE"
{
    // --------------------------------------------------------------------------------
    // -- XMLport automatically created with Dynamics NAV XMLport Generator 1.3.0.2
    // -- Copyright ’ 2007-2012 Carsten Scholling
    // --------------------------------------------------------------------------------

    UseDefaultNamespace = true;

    schema
    {
        textelement(result)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            XmlName = 'result';
            textelement(head)
            {
                MaxOccurs = Once;
                MinOccurs = Once;
                XmlName = 'head';
                textelement(sistema_origen)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'sistema_origen';
                }
                textelement(pais_origen)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'pais_origen';
                }
                textelement(fecha_origen)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'fecha_origen';
                }
                textelement(fecha)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'fecha';
                }
                textelement(tipo)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    TextType = Text;
                    XmlName = 'tipo';
                }
                textelement(id_mensaje)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'id_mensaje';
                }
                textelement(ok)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'ok';

                    trigger OnBeforePassVariable()
                    begin
                        //IF NOT IsOk THEN
                        //  currXMLport.SKIP;
                    end;
                }
                textelement(error)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'error';
                    textelement(code)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'code';
                    }
                    textelement(description)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'description';
                    }

                    trigger OnBeforePassVariable()
                    begin
                        //IF IsOk THEN
                        currXMLport.Skip;
                    end;
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


    procedure SetInfo(var New_id_mensaje: Text[36]; var New_Tipo: Text[20]; var FechaOrigen: Text[30]; var PaisOrigen: Text[20]): Text
    var
        ConfSant: Record "Config. Empresa";
        XmlDomMngt: Codeunit "XML DOM Management";
        /*         XmlDoc: DotNet XmlDocument;
                XmlNode: DotNet XmlNode;
                XmlNode2: DotNet XmlNode;
                XmlNode3: DotNet XmlNode;
                XmlNode4: DotNet XmlNode;
                XmlNodeList: DotNet XmlNodeList; */
        i: Integer;
    begin
        ConfSant.Get;

        sistema_origen := ConfSant.GetSistemaOrigen;
        pais_origen := PaisOrigen;
        fecha_origen := FechaOrigen;
        fecha := Format(CurrentDateTime, 0, 9);
        tipo := New_Tipo;
        id_mensaje := New_id_mensaje;
        ok := '1'
    end;
}

