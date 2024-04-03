# dsOMOPHelper

## Introduction

<img src="man/figures/dsomophelper_logo.png" align="left" height="140" style="margin-right: 10px;" />

The `dsOMOPHelper` package is an extension of [**`dsOMOPClient`**](https://github.com/isglobal-brge/dsOMOPClient), designed to streamline the interaction with databases in the [Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM)](https://www.ohdsi.org/data-standardization/) format within the [DataSHIELD](https://datashield.org/) environment. This package simplifies the process of fetching tables and integrating them into the DataSHIELD workflow, adhering to the privacy standards and disclosure control mechanisms of DataSHIELD.

By combining commands from both `dsOMOPClient` and `dsBaseClient` (which invokes standard DataSHIELD workflow operations), `dsOMOPHelper` significantly reduces the complexity involved in utilizing `dsOMOPClient` for common use cases. This is particularly beneficial for epidemiological studies that require data from an OMOP CDM database to be analyzed securely within the DataSHIELD framework.

While `dsOMOPHelper` significantly enhances the functionality of `dsOMOPClient` by catering to common research needs, it is important to note that for more specific use cases, the functions of `dsOMOPHelper` may not offer sufficient flexibility. In such instances, the operations of `dsOMOPClient` should be directly utilized to ensure the desired outcomes. For users requiring advanced functionalities, exploring the comprehensive documentation of `dsOMOPClient` is highly recommended to fully leverage the potential of this tool in complex research scenarios: [https://github.com/isglobal-brge/dsOMOPClient](https://github.com/isglobal-brge/dsOMOPClient).

We strongly encourage the community to contribute by creating packages similar to `dsOMOPHelper` that are built on top of `dsOMOPClient`. By leveraging the foundational capabilities of `dsOMOPClient`, developers can craft specialized tools that address specific needs emerging at the intersection between the OMOP CDM and DataSHIELD environments.

## Installation

To install the package `dsOMOPHelper`, follow the steps below. This guide assumes you have R installed on your system and the necessary permissions to install R packages.

The `dsOMOPHelper` package can be installed directly from GitHub using the `devtools` package. If you do not have `devtools` installed, you can install it using the following command in R:
```
install.packages("devtools")
```

You can then install the `dsOMOPHelper` package using the following command in R:
```
devtools::install_github('isglobal-brge/dsOMOPHelper')
```

## Acknowledgements

- The development of dsOMOP has been supported by the **[RadGen4COPD](https://github.com/isglobal-brge/RadGen4COPD)**, **[P4COPD](https://www.clinicbarcelona.org/en/projects-and-clinical-assays/detail/p4copd-prediction-prevention-personalized-and-precision-management-of-copd-in-young-adults)**, and **[DATOS-CAT](https://datos-cat.github.io/LandingPage)** projects. These collaborations have not only provided essential financial backing but have also affirmed the project's relevance and application in significant research endeavors.
- This project has received funding from the **[Spanish Ministry of Science and Innovation](https://www.ciencia.gob.es/en/)** and **[State Research Agency](https://www.aei.gob.es/en)** through the **“Centro de Excelencia Severo Ochoa 2019-2023” Program [CEX2018-000806-S]** and **[State Research Agency](https://www.aei.gob.es/en)** and **[Fondo Europeo de Desarrollo Regional, UE](https://ec.europa.eu/regional_policy/funding/erdf_en) (PID2021-122855OB-I00)**, and support from the **[Generalitat de Catalunya](https://web.gencat.cat/en/inici/index.html)** through the **CERCA Program** and **[Ministry of Research and Universities](https://recercaiuniversitats.gencat.cat/en/inici/) (2021 SGR 01563)**.
- This project has received funding from the **"Complementary Plan for Biotechnology Applied to Health"**, coordinated by the **[Institut de Bioenginyeria de Catalunya (IBEC)](https://ibecbarcelona.eu/)** within the framework of the **Recovery, Transformation, and Resilience Plan (C17.I1)** - Funded by the **[European Union](https://european-union.europa.eu/index_en)** - **[NextGenerationEU](https://next-generation-eu.europa.eu/index_en)**.
- Special thanks to **[Xavier Escribà-Montagut](https://github.com/ESCRI11)** for his invaluable support in the development process.

## Contact

For further information or inquiries, please contact:

- **Juan R González**: juanr.gonzalez@isglobal.org
- **David Sarrat González**: david.sarrat@isglobal.org

For more details about **DataSHIELD**, visit [https://www.datashield.org](https://www.datashield.org).

For more information about the **Barcelona Institute for Global Health (ISGlobal)**, visit [https://www.isglobal.org](https://www.isglobal.org).
