*** Settings ***
Documentation     Starter robot for the Beginners' course.

*** Settings ***
Library          RPA.Browser.Selenium
Library          RPA.HTTP
Library          RPA.Robocloud.Secrets
Library          RPA.Excel.Files
Library          RPA.PDF
Variables        variables.py
Suite Teardown   Close All Browsers

*** Variables ***
${WEBSITE_URL}    %{WEBSITE_URL}
${RPA_EXCEL_FILE}    %{RPA_EXCEL_FILE}
${RPA_SECRET_NAME}    %{RPA_SECRET_NAME}
${GLOBAL_RETRY_AMOUNT}=        3x
${GLOBAL_RETRY_INTERVAL}=      1s

*** Keywords ***
Open Internet Browser and website
    Open Available Browser    ${WEBSITE_URL}
    Wait Until Page Contains Element    id:username 
    [Teardown]    Capture Page Screenshot

*** Keywords ***
Login into web Site
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY_AMOUNT}    ${GLOBAL_RETRY_INTERVAL}     Open Internet Browser and website
    Input Text    id:username    ${USER_NAME}
    Input Password    id:password    ${PASSWORD}
    Submit Form
    Wait Until Page Contains Element    id:sales-form
    [Teardown]    Capture Page Screenshot

*** Keywords ***
Download excel file
    Download    ${WEBSITE_URL}${RPA_EXCEL_FILE}    overwrite=True
    [Teardown]    Capture Page Screenshot

*** Keywords ***
Obtain excel data from file
    Open Workbook    ${RPA_EXCEL_FILE}
    ${sales_reps}=    Read Worksheet As Table    header=True
    Close Workbook
    FOR     ${sales_rep}    IN    @{sales_reps}
            Fill and submit Form    ${sales_rep}
    END
    [Teardown]    Capture Page Screenshot

*** Keywords ***
Fill and submit Form
    Wait Until Page Contains Element    id:sales-form
    [Arguments]    ${sales_rep}
    Input Text    firstname    ${sales_rep}[First Name]
    Input Text    lastname    ${sales_rep}[Last Name]
    Input Text    salesresult    ${sales_rep}[Sales]
    Select From List By Value    salestarget    ${sales_rep}[Sales Target]
    Click Button    Submit
    [Teardown]    Capture Page Screenshot

*** Keywords ***
Collect The Results
    Screenshot    css:div.sales-summary    ${CURDIR}${/}output${/}sales_summary.png
    [Teardown]    Capture Page Screenshot

*** Keywords ***
Export The Table As A PDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=    Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf    ${sales_results_html}    ${CURDIR}${/}output${/}sales_results.pdf
    [Teardown]    Capture Page Screenshot

*** Keywords ***
Log Out
    Click Button    Log out
    [Teardown]    Capture Page Screenshot


*** Keywords ***
Close The Browser
    Close Browser
    [Teardown]    Capture Page Screenshot


*** Tasks ***
Insert the sales data for the week and export it as a PDF
    Download excel file
    Login into web Site
    Obtain excel data from file
    Collect The Results
    Export The Table As A PDF
    Log Out
    [Teardown]     Close The Browser