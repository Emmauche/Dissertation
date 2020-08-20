# A pipeline consists of transformers and estimators
#######################################################
# Atransformer is used to apply transformation to a dataframe and
# return another dataframe often comprises of the original dataframe with new column appended
#######################################################
# An estimator is used to create transformer giving some training data
# example below
library(sparklyr)
library(dplyr)
sc<- spark_connect(master = "local") 
# next we create an estimator
scaler <- ft_standard_scaler(sc, input_col = "features",output_col = "features_scaled", with_mean = TRUE)
scaler
# now we create some data and then fit our scaling model to it using the ml_fit() function
df <- copy_to(sc, data.frame(copy_to(sc, data.frame(value = rnorm(100000))))) %>% ft_vector_assembler(input_cols = "value", output_col = "features")
# fitting
scaler_model <- ml_fit(scaler,df)
scaler_model
# Note that in spark ML, many algorithms and feature transformers require that the input be a vector column
# The function ft_vector_assembler() performs this task
# next we will create a transformer using the ml_transform() function
scaler_model %>% ml_transform(df) %>% glimpse()
#############################################################################################
# Now we have seen how the tranformer and estimator works, we delve into pipeline in full
# A pipeline is simply a sequence of transformers and estimators
# A pipeline model is a pipeline that has been trained on data, so all of its components have been converted to transformers
# Pipeline can be created by two approaches using ml_pipeline() function
# 1) Initialize an empty pipeline and append stages
# 2) pass stages directly in pipeline function
# the first
 ml_pipeline(sc) %>% ft_standard_scaler(
   input_col = "features",
   output_col = "features_scaled",
   with_mean = TRUE
 )
# then second
pipeline <- ml_pipeline(scaler)
# the we fit the pipeline just like we did for estimator
pipeline_model<- ml_fit(pipeline,df)
pipeline_model
 # working with our okc data
okc_train <- spark_read_parquet(sc, "data/okc-train.parquet")
