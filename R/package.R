library(qeML)
library(freqparcoord)
library(fairml)
library(plotly)
library(quantmod)
library(assertthat)
library(purrr)

# plots a contour of the difference between z1_col and z2_col
# df is the table containing the columns z1_col, z2_col, x_col, y_col
# z1_col, z2_col is the column name for the target columns
# x_col is the column name for the x axis
# y_col is the column name for the y axis
# x1, x2 is the range of x axis
# y1, y2 is the range of y axis
diff_contour <- function(df, z1_col, z2_col, x_col, y_col, x1, x2, y1, y2) {
    if (missing(x1) || missing(x2)) {
        x1 <- min(df[[x_col]])
        x2 <- max(df[[x_col]])
    }
    if (missing(y1) || missing(y2)) {
        y1 <- min(df[[y_col]])
        y2 <- max(df[[y_col]])
    }

    dffs <- df[[z1_col]] - df[[z2_col]]
    df$dffs_ = dffs

    filtered_df <- df[x1 <= df[[x_col]] & df[[x_col]] <= x2 & y1 <= df[[y_col]] & df[[y_col]] <= y2, ]

    fig <- plot_ly(
        x = filtered_df[[x_col]], 
        y = filtered_df[[y_col]], 
        z = filtered_df$dffs_, 
        type = "contour" 
    )
    df$dffs_ <- NULL
    fig
}

# plots parallel coordinates of the difference between df$z1_col and z2_col
# z1_col, z2_col is the name of the columns used to group lines into classes 
# a class is broken down into dffs > eps, dffs < eps, and neither
# dispcol is a vector of column indices/names to use
# m is the number of lines to display
diff_parallel_coords <- function(df, z1_col, z2_col, dispcols, m = 25, eps = 0.1) {
    dffs <- df[[z1_col]] - df[[z2_col]]
    df$dffs_ = dffs

    class_tmp <- rep(0, length(df$dffs_))
    class_tmp[df$dffs_ > eps] <- 1 
    class_tmp[df$dffs_ < eps] <- -1
    df$class_tmp <- tmp

    unique_class_temp <- unique(df)
    
    dispcols <- map_vec(dispcols, function(col_name) {
        if (is.string(col_name)) {
            return(match(col_name, names(df)))
        } else {
            return(col_name)
        }
    })

    freqparcoord(unique_class_temp, m, dispcols, grpvar=match("class_tmp", names(df)), method="maxdens")
}


cmps <- compas[,c(1,2,4,5,7:10)]
old_pred <- compas$decile_score / 10

xgbout <- qeXGBoost(cmps, 'two_year_recid', holdout=NULL)
new_pred <- predict(xgbout, cmps[,-7])$probs[,2]

cmps$old_pred = old_pred
cmps$new_pred = new_pred

print(diff_parallel_coords(cmps, "old_pred", "new_pred", c("age", "priors_count")))